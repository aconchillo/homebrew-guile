class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.2.6.tar.gz"
  sha256 "59954f97652ddd6a1431d39067d1d4d2be71bcb52b5a97d4f99b118caf973cef"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-rpc-0.2.6"
    sha256 cellar: :any_skip_relocation, monterey:     "32ca1d126e84cf47015c3b7ebcdd74e53b1a30c1b96d9804772cab700acfa958"
    sha256 cellar: :any_skip_relocation, big_sur:      "b866c03498b8ae7f21906fad316c8c886a14b5b30d70b1d739716c1e6f4f76cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e05b342b9e03347a17c5da61612d5abe0b84efbbe163d91294692878656378d8"
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
