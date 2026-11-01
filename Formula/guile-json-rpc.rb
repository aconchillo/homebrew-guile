class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.2.11.tar.gz"
  sha256 "6a10390de15a9a991e7bc15d8766a5da7561428f25c2f33592d86b374ca242a1"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-rpc-0.2.11_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff331df180ea8b62f85a4845ae0869a0215e993a362d8e64c4951e480b3b62b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9862b4dfd6d83c01e1187573073fdff751c8a093d7a3d9d940fb6a418354b132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53782d8d04aedc79c77bb657c1662f390fb4067ab5964840e61cdfc06598b59"
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
