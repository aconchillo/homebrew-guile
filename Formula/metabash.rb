class Metabash < Formula
  desc "GNU Guile module for running distributed shell pipelines"
  homepage "https://github.com/artyom-poptsov/metabash"
  url "https://github.com/artyom-poptsov/metabash/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "14182092cf15ffe52b1f7d1014fcc90f242e65be017625f09182546c05d2e8ac"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/metabash-0.0.0_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f9d41fed4c94c7692df956ba534b44c1b7122d6dfc9954e957786aa8c4b3fe03"
    sha256 cellar: :any_skip_relocation, ventura:      "3d37d777986176716b0c8692d627b78cf8cd506a203c32955d14576a619ae890"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "415725877e83ea755e3250f1adef4e29716ba9e125c7c535eb419ff3ec481440"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-ssh"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
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
    metabash = testpath/"metabash.scm"
    metabash.write <<~EOS
      (use-modules (metabash pipe))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", metabash
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 741288b..cb4d631 100644
--- a/configure.ac
+++ b/configure.ac
@@ -48,9 +48,8 @@ GUILE_SITE_DIR

 GUILE_MODULE_REQUIRED([ssh session])

-pkgdatadir="$datadir/$PACKAGE"
 if test "x$guilesitedir" = "x"; then
-   guilesitedir="$pkgdatadir"
+   guilesitedir="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION"
 fi
 AC_SUBST([guilesitedir])

diff --git a/modules/metabash/Makefile.am b/modules/metabash/Makefile.am
index cec7f57..7d2b6de 100644
--- a/modules/metabash/Makefile.am
+++ b/modules/metabash/Makefile.am
@@ -25,7 +25,7 @@ SOURCES = 				\
 	process.scm

 GOBJECTS = $(SOURCES:%.scm=%.go)
-moddir=$(guilesitedir)/dsv
+moddir=$(guilesitedir)/metabash
 nobase_dist_mod_DATA = $(SOURCES)

 ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/dsv
diff --git a/modules/metabash/Makefile.am b/modules/metabash/Makefile.am
index 7d2b6de..7853638 100644
--- a/modules/metabash/Makefile.am
+++ b/modules/metabash/Makefile.am
@@ -28,7 +28,7 @@ GOBJECTS = $(SOURCES:%.scm=%.go)
 moddir=$(guilesitedir)/metabash
 nobase_dist_mod_DATA = $(SOURCES)

-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/dsv
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/metabash
 nobase_nodist_ccache_DATA = $(GOBJECTS)

 # Make sure source files are installed first, so that the mtime of
diff --git a/Makefile.am b/Makefile.am
index 8cec451..5828446 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,7 +18,7 @@

 ACLOCAL_AMFLAGS = -I build-aux

-SUBDIRS = am build-aux m4 modules
+SUBDIRS = am build-aux m4 modules/metabash

 gen-ChangeLog:
 	if test -d .git; then				\q
