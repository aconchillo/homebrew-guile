class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.4.5a.tar.gz"
  sha256 "8b8d0d998dbfff01b0ea506eaee078c4ba51cb660a5e8416823f3bee088c8fb2"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-rpc-0.2.11"
    sha256 cellar: :any_skip_relocation, monterey:     "a55c53348ff336b40ee693fa7cfba1c74ffc6d4fcca26056d4db25c28cf6339f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3aeb8b7c63b77d959b35966311a941cebc5d0e03d56cfb348823dc46eddb6be"
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
