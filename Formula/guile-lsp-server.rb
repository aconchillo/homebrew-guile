class GuileLspServer < Formula
  desc "LSP Server for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-lsp-server"
  url "https://codeberg.org/rgherdt/scheme-lsp-server/archive/0.2.1.tar.gz"
  sha256 "fc625eea8f6a8abed3afa14b0a552a0c498223d5d5b842b3c4f0c2ac9461f159"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lsp-server-0.2.1"
    sha256 cellar: :any_skip_relocation, monterey:     "e377aa80f850e6b31ae07c5727a2b80c4cc812d6fae2da729e09792625eb391d"
    sha256 cellar: :any_skip_relocation, big_sur:      "92e668f086fb0f4a2fd73e088f35a9d15b75eedf9ead26b4b758220d291e3c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc0ec16b67e7e6cd06bdcdf75a964f2712d4ef10cedc0b9ef9041542086d9b04"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-json-rpc"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    chdir "guile" do
      system "./configure", "--prefix=#{prefix}"
      # Getting runtime issues without -j1. Probably due to the fact that some
      # files get auto generated.
      system "make", "-j1"
      system "make", "install"
    end
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
    lsp_server = testpath/"lsp_server.scm"
    lsp_server.write <<~EOS
      (use-modules (lsp-server guile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", lsp_server
  end
end
