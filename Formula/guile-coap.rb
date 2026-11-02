class GuileCoap < Formula
  desc "CoAP module for Guile"
  homepage "https://codeberg.org/eris/guile-coap"
  url "https://codeberg.org/eris/guile-coap/archive/v0.2.0.tar.gz"
  sha256 "cd62bb26762f83a20664629548ee82cb058d71f6aab04d26ad0ed2e46a6763a2"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-coap-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2ca1a3e33735cb5ab97930aa7be97df9cabfa0298d6fadb83d9157da106e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e490ad9ecedc352d87f1ec63388918c2152015a520ce1e0271fc139a39ba828d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e4137c9743c328cec8fca5569961190a6c89dcc4e9a55ae0e3ffac874b8d02"
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
