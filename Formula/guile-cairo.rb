class GuileCairo < Formula
  desc "Guile wrapper for the Cairo graphics library"
  homepage "https://www.nongnu.org/guile-cairo/"
  url "https://download.savannah.gnu.org/releases/guile-cairo/guile-cairo-1.11.1.tar.gz"
  sha256 "f4f6337eb5c90fc2f5fd2043de6f237ef336da6285ae042b8452379bb22086bd"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-cairo-1.11.1"
    sha256 catalina:     "904cbb284c05b7d6d6fd53c396b93162396187d47271b96ea3b6b9f42150c6fd"
    sha256 x86_64_linux: "71692c6ef87dbcf4e25ffdc349a1843ce991bc118ad5672e7620ce283c96b19d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chmod 0755, "build-aux/git-version-gen"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/cairo/config.go"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
    EOS
  end

  test do
    cairo = testpath/"cairo.scm"
    cairo.write <<~EOS
      (use-modules (cairo))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", cairo
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index aaf2507..94cd012 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -28,9 +28,20 @@ ACLOCAL_AMFLAGS = -I m4

 CLEANFILES = env

-scmdir=$(prefix)/share/guile/site
+GOBJECTS = $(SOURCES:%.scm=%.go)

-scm_DATA = cairo.scm
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)
+objdir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
+
+nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
+nobase_nodist_obj_DATA = $(GOBJECTS)
+
+GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
+SUFFIXES = .scm .go
+.scm.go:
+	$(top_builddir)/env $(GUILD) compile $(GUILE_TARGET) $(GUILE_WARNINGS) -o "$@" "$<"
+
+SOURCES = cairo.scm

 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = guile-cairo.pc
diff --git a/cairo/Makefile.am b/cairo/Makefile.am
index f4959af..05b5973 100644
--- a/cairo/Makefile.am
+++ b/cairo/Makefile.am
@@ -15,29 +15,26 @@
 # License along with this program.  If not, see
 # <http://www.gnu.org/licenses/>.

-all-local: config.scm
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/cairo
+objdir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/cairo

-lib_builddir = $(shell cd $(top_builddir)/guile-cairo && pwd)
-docs_builddir = $(shell cd $(top_builddir)/doc && pwd)
+SOURCES = config.scm vector-types.scm
+NOCOMP_SOURCES = cairo-procedures.txt

-moduledir=$(prefix)/share/guile/site/cairo
+GOBJECTS = $(SOURCES:%.scm=%.go)

-module_DATA = vector-types.scm cairo-procedures.txt
+nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
+nobase_nodist_obj_DATA = $(GOBJECTS)

-config.scm: Makefile config.scm.in
-	sed -e "s|@cairolibpath\@|$(lib_builddir)/libguile-cairo|" \
-	    -e "s|@cairodocumentationpath\@|$(docs_builddir)/cairo-procedures.txt|" \
-	    $(srcdir)/config.scm.in > config.scm
+GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
+SUFFIXES = .scm .go
+.scm.go:
+	$(top_builddir)/env $(GUILD) compile $(GUILE_TARGET) $(GUILE_WARNINGS) -o "$@" "$<"

-install-data-local: Makefile config.scm.in
-	$(mkinstalldirs) $(DESTDIR)$(moduledir)
+config.scm: Makefile config.scm.in
 	sed -e "s|@cairolibpath\@|$(libdir)/libguile-cairo|" \
-	    -e "s|@cairodocumentationpath\@|$(moduledir)/cairo-procedures.txt|" \
-	    $(srcdir)/config.scm.in > $(DESTDIR)$(moduledir)/config.scm
-	chmod 644 $(DESTDIR)$(moduledir)/config.scm
-
-uninstall-local:
-	rm -f $(DESTDIR)$(moduledir)/config.scm
+	    -e "s|@cairodocumentationpath\@|$(moddir)/cairo-procedures.txt|" \
+	    $(srcdir)/config.scm.in > config.scm

 cairo-procedures.txt.update:
 	echo "Generated from upstream documentation; see COPYING.docs for info." \
@@ -45,6 +42,6 @@ cairo-procedures.txt.update:
 	$(top_srcdir)/doc/docbook-to-guile-doc $(CAIRO_XML_DIR)/*.xml \
 	  >> $(srcdir)/cairo-procedures.txt

-CLEANFILES = config.scm
+CLEANFILES = config.scm $(GOBJECTS)

-EXTRA_DIST = config.scm.in $(module_DATA)
+EXTRA_DIST = config.scm.in
diff --git a/configure.ac b/configure.ac
index 31a3367..78b7414 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,9 +77,15 @@ AC_SUBST(AM_LDFLAGS)
 # Check for Guile
 #
 GUILE_PKG
+GUILE_PROGS
 GUILE_FLAGS
 AC_SUBST(GUILE_EFFECTIVE_VERSION)

+if test "$cross_compiling" != no; then
+   GUILE_TARGET="--target=$host_alias"
+   AC_SUBST([GUILE_TARGET])
+fi
+
 PKG_CHECK_MODULES(CAIRO, cairo >= 1.10.0)
 AC_SUBST(CAIRO_LIBS)
 AC_SUBST(CAIRO_CFLAGS)
diff --git a/build-aux/git-version-gen b/build-aux/git-version-gen
new file mode 100755
index 0000000..87c7573
--- /dev/null
+++ b/build-aux/git-version-gen
@@ -0,0 +1,231 @@
+ #!/bin/sh
+ # Print a version string.
+ scriptversion=2017-01-09.19; # UTC
+
+ # Copyright (C) 2007-2017 Free Software Foundation, Inc.
+ #
+ # This program is free software: you can redistribute it and/or modify
+ # it under the terms of the GNU General Public License as published by
+ # the Free Software Foundation; either version 3 of the License, or
+ # (at your option) any later version.
+ #
+ # This program is distributed in the hope that it will be useful,
+ # but WITHOUT ANY WARRANTY; without even the implied warranty of
+ # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ # GNU General Public License for more details.
+ #
+ # You should have received a copy of the GNU General Public License
+ # along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+ # This script is derived from GIT-VERSION-GEN from GIT: http://git.or.cz/.
+ # It may be run two ways:
+ # - from a git repository in which the "git describe" command below
+ #   produces useful output (thus requiring at least one signed tag)
+ # - from a non-git-repo directory containing a .tarball-version file, which
+ #   presumes this script is invoked like "./git-version-gen .tarball-version".
+
+ # In order to use intra-version strings in your project, you will need two
+ # separate generated version string files:
+ #
+ # .tarball-version - present only in a distribution tarball, and not in
+ #   a checked-out repository.  Created with contents that were learned at
+ #   the last time autoconf was run, and used by git-version-gen.  Must not
+ #   be present in either $(srcdir) or $(builddir) for git-version-gen to
+ #   give accurate answers during normal development with a checked out tree,
+ #   but must be present in a tarball when there is no version control system.
+ #   Therefore, it cannot be used in any dependencies.  GNUmakefile has
+ #   hooks to force a reconfigure at distribution time to get the value
+ #   correct, without penalizing normal development with extra reconfigures.
+ #
+ # .version - present in a checked-out repository and in a distribution
+ #   tarball.  Usable in dependencies, particularly for files that don't
+ #   want to depend on config.h but do want to track version changes.
+ #   Delete this file prior to any autoconf run where you want to rebuild
+ #   files to pick up a version string change; and leave it stale to
+ #   minimize rebuild time after unrelated changes to configure sources.
+ #
+ # As with any generated file in a VC'd directory, you should add
+ # /.version to .gitignore, so that you don't accidentally commit it.
+ # .tarball-version is never generated in a VC'd directory, so needn't
+ # be listed there.
+ #
+ # Use the following line in your configure.ac, so that $(VERSION) will
+ # automatically be up-to-date each time configure is run (and note that
+ # since configure.ac no longer includes a version string, Makefile rules
+ # should not depend on configure.ac for version updates).
+ #
+ # AC_INIT([GNU project],
+ #         m4_esyscmd([build-aux/git-version-gen .tarball-version]),
+ #         [bug-project@example])
+ #
+ # Then use the following lines in your Makefile.am, so that .version
+ # will be present for dependencies, and so that .version and
+ # .tarball-version will exist in distribution tarballs.
+ #
+ # EXTRA_DIST = $(top_srcdir)/.version
+ # BUILT_SOURCES = $(top_srcdir)/.version
+ # $(top_srcdir)/.version:
+ #	echo $(VERSION) > $@-t && mv $@-t $@
+ # dist-hook:
+ #	echo $(VERSION) > $(distdir)/.tarball-version
+
+
+ me=$0
+
+ version="git-version-gen $scriptversion
+
+ Copyright 2011 Free Software Foundation, Inc.
+ There is NO warranty.  You may redistribute this software
+ under the terms of the GNU General Public License.
+ For more information about these matters, see the files named COPYING."
+
+ usage="\
+ Usage: $me [OPTION]... \$srcdir/.tarball-version [TAG-NORMALIZATION-SED-SCRIPT]
+ Print a version string.
+
+ Options:
+
+    --prefix PREFIX    prefix of git tags (default 'v')
+    --match            pattern for git tags to match (default: '\$prefix*')
+    --fallback VERSION
+                       fallback version to use if \"git --version\" fails
+
+    --help             display this help and exit
+    --version          output version information and exit
+
+ Running without arguments will suffice in most cases."
+
+ prefix=v
+ fallback=
+
+ unset match
+ unset tag_sed_script
+
+ while test $# -gt 0; do
+   case $1 in
+     --help) echo "$usage"; exit 0;;
+     --version) echo "$version"; exit 0;;
+     --prefix) shift; prefix=${1?};;
+     --match) shift; match="$1";;
+     --fallback) shift; fallback=${1?};;
+     -*)
+       echo "$0: Unknown option '$1'." >&2
+       echo "$0: Try '--help' for more information." >&2
+       exit 1;;
+     *)
+       if test "x$tarball_version_file" = x; then
+         tarball_version_file="$1"
+       elif test "x$tag_sed_script" = x; then
+         tag_sed_script="$1"
+       else
+         echo "$0: extra non-option argument '$1'." >&2
+         exit 1
+       fi;;
+   esac
+   shift
+ done
+
+ if test "x$tarball_version_file" = x; then
+     echo "$usage"
+     exit 1
+ fi
+
+ match="${match:-$prefix*}"
+ tag_sed_script="${tag_sed_script:-s/x/x/}"
+
+ nl='
+ '
+
+ # Avoid meddling by environment variable of the same name.
+ v=
+ v_from_git=
+
+ # First see if there is a tarball-only version file.
+ # then try "git describe", then default.
+ if test -f $tarball_version_file
+ then
+     v=`cat $tarball_version_file` || v=
+     case $v in
+         *$nl*) v= ;; # reject multi-line output
+         [0-9]*) ;;
+         *) v= ;;
+     esac
+     test "x$v" = x \
+         && echo "$0: WARNING: $tarball_version_file is missing or damaged" 1>&2
+ fi
+
+ if test "x$v" != x
+ then
+     : # use $v
+ # Otherwise, if there is at least one git commit involving the working
+ # directory, and "git describe" output looks sensible, use that to
+ # derive a version string.
+ elif test "`git log -1 --pretty=format:x . 2>&1`" = x \
+     && v=`git describe --abbrev=4 --match="$match" HEAD 2>/dev/null \
+           || git describe --abbrev=4 HEAD 2>/dev/null` \
+     && v=`printf '%s\n' "$v" | sed "$tag_sed_script"` \
+     && case $v in
+          $prefix[0-9]*) ;;
+          *) (exit 1) ;;
+        esac
+ then
+     # Is this a new git that lists number of commits since the last
+     # tag or the previous older version that did not?
+     #   Newer: v6.10-77-g0f8faeb
+     #   Older: v6.10-g0f8faeb
+     case $v in
+         *-*-*) : git describe is okay three part flavor ;;
+         *-*)
+             : git describe is older two part flavor
+             # Recreate the number of commits and rewrite such that the
+             # result is the same as if we were using the newer version
+             # of git describe.
+             vtag=`echo "$v" | sed 's/-.*//'`
+             commit_list=`git rev-list "$vtag"..HEAD 2>/dev/null` \
+                 || { commit_list=failed;
+                      echo "$0: WARNING: git rev-list failed" 1>&2; }
+             numcommits=`echo "$commit_list" | wc -l`
+             v=`echo "$v" | sed "s/\(.*\)-\(.*\)/\1-$numcommits-\2/"`;
+             test "$commit_list" = failed && v=UNKNOWN
+             ;;
+     esac
+
+     # Change the first '-' to a '.', so version-comparing tools work properly.
+     # Remove the "g" in git describe's output string, to save a byte.
+     v=`echo "$v" | sed 's/-/./;s/\(.*\)-g/\1-/'`;
+     v_from_git=1
+ elif test "x$fallback" = x || git --version >/dev/null 2>&1; then
+     v=UNKNOWN
+ else
+     v=$fallback
+ fi
+
+ v=`echo "$v" |sed "s/^$prefix//"`
+
+ # Test whether to append the "-dirty" suffix only if the version
+ # string we're using came from git.  I.e., skip the test if it's "UNKNOWN"
+ # or if it came from .tarball-version.
+ if test "x$v_from_git" != x; then
+   # Don't declare a version "dirty" merely because a timestamp has changed.
+   git update-index --refresh > /dev/null 2>&1
+
+   dirty=`exec 2>/dev/null;git diff-index --name-only HEAD` || dirty=
+   case "$dirty" in
+       '') ;;
+       *) # Append the suffix only if there isn't one already.
+           case $v in
+             *-dirty) ;;
+             *) v="$v-dirty" ;;
+           esac ;;
+   esac
+ fi
+
+ # Omit the trailing newline, so that m4_esyscmd can use the result directly.
+ printf %s "$v"
+
+ # Local variables:
+ # eval: (add-hook 'write-file-hooks 'time-stamp)
+ # time-stamp-start: "scriptversion="
+ # time-stamp-format: "%:y-%02m-%02d.%02H"
+ # time-stamp-time-zone: "UTC0"
+ # time-stamp-end: "; # UTC"
+ # End:
