class GuileLzma < Formula
  desc "GNU Guile bindings to the XZ compression library"
  homepage "https://ngyro.com/software/guile-lzma.html"
  url "https://files.ngyro.com/guile-lzma/guile-lzma-0.1.1.tar.gz"
  sha256 "2b866896d672ed4d39008f4b5336750d7897560a06678365f5c5a72bd2fcce5e"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzma-0.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "784de7f25a28ef47f3647d141fb6c6ba66617aec3ac24053f65770b1ef3dfe2c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-bytestructures"
  depends_on "xz"

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

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/lzma/config.go"
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
    lzma = testpath/"lzma.scm"
    lzma.write <<~EOS
      (use-modules (lzma))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", lzma
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 71ad6fe..fc37423 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,22 +27,49 @@ AM_SILENT_RULES([yes])

 AC_CANONICAL_HOST

-PKG_PROG_PKG_CONFIG
-
-AC_MSG_CHECKING([for liblzma directory])
-PKG_CHECK_VAR([LIBLZMA_LIBDIR], [liblzma], [libdir],
-  [AC_MSG_RESULT([$LIBLZMA_LIBDIR])],
-  [AC_MSG_RESULT([no])
-   AC_MSG_FAILURE(['liblzma' directory not found])])
-
 GUILE_PKG([3.0])
 GUILE_PROGS
+GUILE_SITE_DIR
+if test "x$GUILD" = "x"; then
+   AC_MSG_ERROR(['guild' binary not found; please check your GNU Guile installation.])
+fi
+
+if test "$cross_compiling" != no; then
+   GUILE_TARGET="--target=$host_alias"
+   AC_SUBST([GUILE_TARGET])
+fi
+
+AC_DEFUN([GUILE_LIBLZMA_FILE_NAME], [
+  AC_REQUIRE([PKG_PROG_PKG_CONFIG])
+  AC_CACHE_CHECK([liblzma's file name],
+    [guile_cv_liblzma_libdir],
+    [if test "$cross_compiling" = yes; then
+       # When cross-compiling, we cannot rely on 'ldd'.  Instead, look
+       # the output of 'ld --verbose', assuming we're using GNU ld.
+       echo 'int main () { return lzma_version_number(); }' > conftest.c
+       guile_cv_liblzma_libdir="\
+          `$CC conftest.c -o conftest$EXEEXT -llz -Wl,--verbose 2>/dev/null \
+          | grep -E '^/.*/liblzma\.(a|so)'`"
+       rm -f conftest.c conftest$EXEEXT
+     else
+       old_LIBS="$LIBS"
+       LIBS="-llzma"
+       AC_LINK_IFELSE([AC_LANG_SOURCE([int main () { return lzma_version_number(); }])],
+	 [guile_cv_liblzma_libdir="`ldd conftest$EXEEXT | grep liblzma | sed '-es/.*=> \(.*\) .*$/\1/g'`"])
+       LIBS="$old_LIBS"
+     fi])
+  $1="$guile_cv_liblzma_libdir"
+])

-AC_ARG_VAR([GUILD], [guild (Guile compiler) command])
-AS_IF([test "x$GUILD" = "x"],
-  [PKG_CHECK_VAR([GUILD], [guile-$GUILE_EFFECTIVE_VERSION], [guild], [],
-    [AC_MSG_ERROR(m4_normalize([
-      'guild' binary not found; please check your Guile installation.]))])])
+dnl Library name of liblzma suitable for 'dynamic-link'.
+GUILE_LIBLZMA_FILE_NAME([LIBLZMA_LIBDIR])
+if test "x$LIBLZMA_LIBDIR" = "x"; then
+  LIBLZMA_LIBDIR="liblzma"
+else
+  # Strip the .so or .so.1 extension since that's what 'dynamic-link' expects.
+  LIBLZMA_LIBDIR="`echo $LIBLZMA_LIBDIR | sed -es'/\.so\(\.[[0-9.]]\+\)\?//g'`"
+fi
+AC_SUBST([LIBLZMA_LIBDIR])

 AC_CONFIG_FILES([lzma/config.scm])
 AC_CONFIG_FILES([Makefile])
diff --git a/lzma/config.scm.in b/lzma/config.scm.in
index f707b60..cb01922 100644
--- a/lzma/config.scm.in
+++ b/lzma/config.scm.in
@@ -19,4 +19,4 @@
 (define-module (lzma config)
   #:export (%lzma-library-path))

-(define %lzma-library-path "@LIBLZMA_LIBDIR@/liblzma")
+(define %lzma-library-path "@LIBLZMA_LIBDIR@")
