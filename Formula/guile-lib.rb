class GuileLib < Formula
  desc "Accumulation place for pure-scheme Guile modules"
  homepage "https://www.nongnu.org/guile-lib/"
  url "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-0.2.7.tar.gz"
  sha256 "e4ef3b845f121882c7c0cf04f81a1cb8fd360c6f64b56b868de5546214f904de"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lib-0.2.7_1"
    sha256 cellar: :any_skip_relocation, big_sur:      "0fdcfdbafc23dc90c265c28ba1ffdedc5246bcb1a55dd18a8b322935cc8bb899"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "139ec6f77f0baa56d16a7c45053ee5f6a2d0f2e8e1fdbf07ba809c26dd8d1f51"
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
