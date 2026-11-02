class GuileLzma < Formula
  desc "GNU Guile bindings to the XZ compression library"
  homepage "https://ngyro.com/software/guile-lzma.html"
  url "https://files.ngyro.com/guile-lzma/guile-lzma-0.1.1.tar.gz"
  sha256 "2b866896d672ed4d39008f4b5336750d7897560a06678365f5c5a72bd2fcce5e"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzma-0.1.1_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acd56d40eabfb0895838f7e197ed9df6c1241553e1a024c3c9a52c1d84d5933c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1451b8c9d8fe1fe1b4453d56360ccd903711342eb20d48d29236480ba355652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9a4b746c4a6d7c980b45fe16da3ffd9330a7b586c856cf9a5ef98affe894d4"
  end

  depends_on "guile"
  depends_on "guile-bytestructures"
  depends_on "xz"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  post_install_steps do
    # Touch config.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/lzma/config.go"
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
