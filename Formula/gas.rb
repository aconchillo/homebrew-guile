class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f32566e662b08a700e72c6f79d525914651d67d5be898f3109d91d52029c815d"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/gas-0.1.0_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "6ff612ee65ea7ed5746f4416a3de9ff2d38185aeb65991f968fa4c8457bce66c"
    sha256 cellar: :any_skip_relocation, ventura:      "e776a827a724f7b65692568adc3b43c6e66b72c1677bc5c8626504c4d5b3e789"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "57c7a4be76ca91c9ce140df0877ff07225ea4424eb3b06e7f70fcd2e73b9e47b"
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

    system "#{bin}/gas", gas
  end
end
