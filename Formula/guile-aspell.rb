class GuileAspell < Formula
  desc "Spellcheck Library for Guile"
  homepage "https://github.com/spk121/guile-aspell"
  url "https://github.com/spk121/guile-aspell/releases/download/0.5.0/guile_aspell-0.5.0.tar.gz"
  sha256 "958e3f1f80bffdc5200778804259384722b94ed0fda5957001fc652f941322a7"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-aspell-0.5.0_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "953348758f05c3b7255e6b465d701607657226ef25deeee2db64d26ef6d85993"
    sha256 cellar: :any_skip_relocation, ventura:      "53570f1cac2fc5c05c95e6d1eda6d4ed0aa56d52b7d2a3a972af1681a68672c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b12c693c71ff890751983c74bc3bc54e0beb5a650b20595abe344429be8a0ac"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "aspell"
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
    aspell = testpath/"aspell.scm"
    aspell.write <<~EOS
      (use-modules (aspell))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", aspell
  end
end
