class GuileJson < Formula
  desc "JSON module for Guile"
  homepage "https://github.com/aconchillo/guile-json"
  url "https://download.savannah.gnu.org/releases/guile-json/guile-json-4.7.3.tar.gz"
  sha256 "38ba048ed29d12f05b32c5b2fb7a51795c448b41e403a2b1b72ff0035817f388"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-4.7.3_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ea7849e68f025f0a829ddce1c797ca2df964928e5a32fa7e542e514e9ff22378"
    sha256 cellar: :any_skip_relocation, ventura:      "cebbfde0089ebb4b94e5d53c18360f60263bda1f943d22535f453777a32dbacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c64639f357a6200c0cc698665f4e346342d6c2a777f749f00230fc5e3f9bce17"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    json = testpath/"json.scm"
    json.write <<~EOS
      (use-modules (json))
      (json-string->scm "1")
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", json
  end
end
