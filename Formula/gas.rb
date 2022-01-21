class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "912ca91ac4fc6b3b4957da838512738b18f14d91eb2f0e5f1d9e6fa74636fedb"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/gas-0.0.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "c0f655044d0f2d7af0691660e66d0297b5605d18c618896d504848104205fe35"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d020d6521d3033d2233ba0b05ef98202f6a305c43961203b985a97c5f1fada76"
  end

  depends_on "guilescript"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    gas = testpath/"gas.gs"
    gas.write <<~EOS
      (log:info "hello from gas")
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "gas", gas
  end
end
