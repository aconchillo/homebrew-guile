class GuileLib < Formula
  desc "Accumulation place for pure-scheme Guile modules"
  homepage "https://www.nongnu.org/guile-lib/"
  url "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-0.2.6.1.tar.gz"
  sha256 "6d1d3d0f14db9d280b8d427d6e1dec4417ddd02bff23bd5982ecb6e262eb3f2a"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lib-0.2.6.1"
    cellar :any_skip_relocation
    sha256 "c19f020c8ed59bcd52ec900ccd45dc70b981a6beda7406e4ddd129daf569b251" => :catalina
    sha256 "d1c935c810211756b07e06c0a851a6aa4aa4b92388a3814602d1f5ac8ddb2a48" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

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
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
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
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
