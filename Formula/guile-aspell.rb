class GuileAspell < Formula
  desc "Spellcheck Library for Guile"
  homepage "https://github.com/spk121/guile-aspell"
  url "https://github.com/spk121/guile-aspell/releases/download/0.5.0/guile_aspell-0.5.0.tar.gz"
  sha256 "958e3f1f80bffdc5200778804259384722b94ed0fda5957001fc652f941322a7"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-aspell-0.5.0_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "036de26c28fea9ea4990408e64d2fc9d7b957369c43240e53f61a9577dc374eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44e7193a7d8b426ef8fd2dbcac3b40a28a003f83d00a488cfa142fa0fa0443d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2abfe69bf5f3a9dc281959241cb510aae048e8726a684305df876199449397c8"
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
