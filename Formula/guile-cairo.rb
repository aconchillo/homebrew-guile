class GuileCairo < Formula
  desc "Guile wrapper for the Cairo graphics library"
  homepage "https://www.nongnu.org/guile-cairo/"
  url "https://git.savannah.gnu.org/git/guile-cairo.git", revision: "74ce9a9696fa8d14ce15c27c4b0da8219f62403f"
  version "1.11.2"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-cairo-1.11.2_2"
    sha256 arm64_sonoma: "19fbf8b59b94b32655aa796eef3b2530889edddf389e146f3ab7d8bbe60ff9e6"
    sha256 ventura:      "b6df3e1db26460ffe1ee09285bb09c8872a8dfcad7d642b8f64aefdba3068b00"
    sha256 x86_64_linux: "7e171f4155c84bf6404a7cee3f37d592eeed7d5df88f15b5bbcda81d9f7b0156"
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
