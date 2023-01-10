class GuileAspell < Formula
  desc "Spellcheck Library for Guile"
  homepage "https://github.com/spk121/guile-aspell"
  url "https://github.com/spk121/guile-aspell/releases/download/0.5.0/guile_aspell-0.5.0.tar.gz"
  sha256 "958e3f1f80bffdc5200778804259384722b94ed0fda5957001fc652f941322a7"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-aspell-0.5.0_1"
    sha256 cellar: :any_skip_relocation, monterey:     "b36dda8bbaf61f53a7976dca15f195d62631c6aa82880b40e81045af0df1a58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4cc257afc154e3192599ec15ebbbf711a93a0483d22c09f0c6f3cb464dc14d7e"
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
