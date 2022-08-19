class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.2.8.tar.gz"
  sha256 "87726c8293852a4a6ebc554ab77cec537a99601bc0b66110d9f816f4cf8b6cf1"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-rpc-0.2.8"
    sha256 cellar: :any_skip_relocation, monterey:     "6e6a0cb123b52d25f304b180e79aba739a6119a707a2429b8d049e1768295834"
    sha256 cellar: :any_skip_relocation, big_sur:      "650633aba91540a0e4bcf10ca13b660b6d3cf5c7e6c238d942ef5ebb5d30b82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e5547c7c499ab73fec3c152ee55c31552b6fd6bca2ad7582e2506ef4c9717c1b"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    json_rpc = testpath/"json-rpc.scm"
    json_rpc.write <<~EOS
      (use-modules (json-rpc))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", json_rpc
  end
end
