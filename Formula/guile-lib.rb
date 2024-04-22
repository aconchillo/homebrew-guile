class GuileLib < Formula
  desc "Accumulation place for pure-scheme Guile modules"
  homepage "https://www.nongnu.org/guile-lib/"
  url "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-0.2.8.tar.gz"
  sha256 "64e902ee0cbb2cee1efb8168c3bf9ed49e0b32a8a23db863e83bf14817d767d9"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lib-0.2.8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b8ae3cc8ff891db3f7ded4a470aec5339983d45dc73869244fa8b2f85526ef62"
    sha256 cellar: :any_skip_relocation, ventura:      "8321728205df22a895eb2a458893d6dca19e176aa6e3a80bca7b0f47c620fc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00ad9680ce606db33aaa69f8c714632488567ccc38db19366eaefae4fe362686"
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
--- a/configure.ac	2022-12-16 15:15:11
+++ b/configure.ac	2022-12-16 15:15:32
@@ -92,8 +92,8 @@
    SITEDIR="$GUILE_GLOBAL_SITE";
    SITECCACHEDIR="$GUILE_SITE_CCACHE";
 else
-   SITEDIR="$datadir/guile-lib";
-   SITECCACHEDIR="$libdir/guile-lib/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
+   SITEDIR="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION";
+   SITECCACHEDIR="$libdir/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
 fi
 AC_SUBST([SITEDIR])
 AC_SUBST([SITECCACHEDIR])
