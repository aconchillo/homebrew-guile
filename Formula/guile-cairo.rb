class GuileCairo < Formula
  desc "Guile wrapper for the Cairo graphics library"
  homepage "https://www.nongnu.org/guile-cairo/"
  url "https://git.savannah.gnu.org/git/guile-cairo.git", revision: "74ce9a9696fa8d14ce15c27c4b0da8219f62403f"
  version "1.11.2"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-cairo-1.11.2"
    sha256 monterey:     "91891459cda39a62b11b06ede963a57a8e87e5030f81d9d79bb2cfd1d5883a84"
    sha256 x86_64_linux: "ff1a3075fee617d07dce6241ef0f88c04dd8f8becb85e832d923488012a201ce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
