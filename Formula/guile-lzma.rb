class GuileLzma < Formula
  desc "GNU Guile bindings to the XZ compression library"
  homepage "https://ngyro.com/software/guile-lzma.html"
  url "https://files.ngyro.com/guile-lzma/guile-lzma-0.1.1.tar.gz"
  sha256 "2b866896d672ed4d39008f4b5336750d7897560a06678365f5c5a72bd2fcce5e"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzma-0.1.1_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "bdae623526507e91990f753679401e9b8f5bd066a9b9ca98e28c3dd8ddde992d"
    sha256 cellar: :any_skip_relocation, ventura:      "db47f0c365a0c40c122a5178730b46c429f3116386643df52f0cadefb46a6657"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7b42ecac34cc1983480b11280fd63bc8497a2de9cfe1d9b02681af571fed658b"
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
