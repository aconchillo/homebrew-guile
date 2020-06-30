class GuileLib < Formula
  desc "An accumulation place for pure-scheme Guile modules"
  homepage "https://www.nongnu.org/guile-lib/"
  url "http://download.savannah.nongnu.org/releases/guile-lib/guile-lib-0.2.6.1.tar.gz"
  sha256 "6d1d3d0f14db9d280b8d427d6e1dec4417ddd02bff23bd5982ecb6e262eb3f2a"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "texinfo"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}", "--with-guile-site=yes"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
    EOS
  end

  test do
    lib = testpath/"lib.scm"
    lib.write <<~EOS
      (use-modules (apicheck))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"

    system "guile", lib
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 07be121..e95a6b0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,8 +83,8 @@ AC_ARG_WITH(
 AC_SUBST([guile_site])

 if test "x$guile_site" = "xyes"; then
-   SITEDIR="$GUILE_GLOBAL_SITE";
-   SITECCACHEDIR="$GUILE_SITE_CCACHE";
+   SITEDIR="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION";
+   SITECCACHEDIR="$libdir/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
 else
    SITEDIR="$datadir/guile-lib";
    SITECCACHEDIR="$libdir/guile-lib/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";