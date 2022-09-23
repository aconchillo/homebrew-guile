class GuileLspServer < Formula
  desc "LSP Server for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-lsp-server"
  url "https://codeberg.org/rgherdt/scheme-lsp-server/archive/0.2.2.tar.gz"
  sha256 "1d1bf313a1050118be717ca8b6fa9a758321850e9816f0f3a1c321b9b839c83b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lsp-server-0.2.2"
    sha256 cellar: :any_skip_relocation, monterey:     "19427903b8eb84b8fa8e14cfaf141e691c63c43e3c81c0ff15f8c5f3c21b051b"
    sha256 cellar: :any_skip_relocation, big_sur:      "c691ebb556e80a9b7e4367e8dfca97778c326c7ddd8dbbdff58abdee216b9572"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b84cede8f517533216d8be253c447f1620e6bcdc3234ccc69c5cbb87d81e6c89"
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
