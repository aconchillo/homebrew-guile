class GuileCoap < Formula
  desc "CoAP module for Guile"
  homepage "https://codeberg.org/eris/guile-coap"
  url "https://codeberg.org/eris/guile-coap/archive/v0.1.0.tar.gz"
  sha256 "6ff9f82d43bf8ccb830331e4347b1a9864163cef381d0cd0f79df5a910d75274"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-coap-0.1.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3dd3efe36f4a08b3cbc2cefa82fa9349bed04ba594584f7926ca5974cf44b745"
    sha256 cellar: :any_skip_relocation, ventura:      "90c94956048f36637b015aa9dcdc0484bc9a5d44d61fb3df8c2fbd0f92660e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3604708f3e3a3cd1d275353e0b18f7604b1fe07283a49c90c720358a1a15b77a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "fibers"
  depends_on "guile"

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
    coap = testpath/"coap.scm"
    coap.write <<~EOS
      (use-modules (coap udp))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", coap
  end
end
