class GuileLspServer < Formula
  desc "LSP Server for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-lsp-server"
  url "https://codeberg.org/rgherdt/scheme-lsp-server/archive/0.1.14.tar.gz"
  sha256 "6fc035909c9ae99031de45406e3121250eeefa4424edba88212e259d6d2e4547"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lsp-server-0.1.8"
    sha256 cellar: :any_skip_relocation, monterey:     "c631fe5a363d70524fdd8cadaf5702f40f98ac77c11d5c6aeaccc1cb3d29e90a"
    sha256 cellar: :any_skip_relocation, big_sur:      "5d730a9139499a907b57db7ac003d746bc2f67d4ae4b653085a16899fe5a0c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13a83adcc9d1e26553e28d046af0ad21e23df1f122b46df121765a993ac97c8a"
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
