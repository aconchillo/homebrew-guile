class GuileAspell < Formula
  desc "Spellcheck Library for Guile"
  homepage "https://github.com/spk121/guile-aspell"
  url "https://github.com/spk121/guile-aspell/releases/download/0.5.0/guile_aspell-0.5.0.tar.gz"
  sha256 "958e3f1f80bffdc5200778804259384722b94ed0fda5957001fc652f941322a7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-aspell-0.5.0"
    sha256 cellar: :any_skip_relocation, catalina:     "0f82210328fc2fc42c918d07580e6b96bcea94eb7e8a7ddea5ddd8c2069c8182"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a58e2c0dbccad7ce6f3f71818c2247f074b9bea19a4fdeed9cdf984f2b3921d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
