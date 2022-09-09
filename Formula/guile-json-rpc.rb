class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.2.10.tar.gz"
  sha256 "57f6a0fa2c902f1fabc73bd5846219f90178b35e3064c6a551a54031ea42f1f2"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-rpc-0.2.10"
    sha256 cellar: :any_skip_relocation, monterey:     "ba82627362993f74b3b8e4c555772b9145b7b404140e39152faccd6d904b1a70"
    sha256 cellar: :any_skip_relocation, big_sur:      "f0fb19ccb6c51e64507794a841096f3843337872e220a93567e2c3219141990b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17fc960c45baf67e7f476380a7a3a985943598485cac6dc508547f55961dcd0c"
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
