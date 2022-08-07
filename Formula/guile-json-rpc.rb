class GuileJsonRpc < Formula
  desc "JSON-RPC module for Guile"
  homepage "https://codeberg.org/rgherdt/scheme-json-rpc"
  url "https://codeberg.org/rgherdt/scheme-json-rpc/archive/0.2.6.tar.gz"
  sha256 "59954f97652ddd6a1431d39067d1d4d2be71bcb52b5a97d4f99b118caf973cef"

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
