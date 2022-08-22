class GuileLspServer < Formula
  desc "LSP Server for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-lsp-server"
  url "https://codeberg.org/rgherdt/scheme-lsp-server/archive/0.1.14.tar.gz"
  sha256 "6fc035909c9ae99031de45406e3121250eeefa4424edba88212e259d6d2e4547"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lsp-server-0.1.14_1"
    sha256 cellar: :any_skip_relocation, monterey:     "9d047185388d7de2e46947624da7c4a4ec4730063ea3b494cf40ec40d1b15f54"
    sha256 cellar: :any_skip_relocation, big_sur:      "3b2f7c8f153ead9e430925073728be568b1a64e68fe6802bca4fb66d6b7b38d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34c0fa3c438159a27a59726476b50d6dbca68b31f8d1dad6ae7e4bf50dc5eaf6"
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
