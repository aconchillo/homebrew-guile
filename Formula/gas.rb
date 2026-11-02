class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f32566e662b08a700e72c6f79d525914651d67d5be898f3109d91d52029c815d"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/gas-0.1.0_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d5c91233c9187cb1b1c39d16dabbe5746bbfe64540e4c728e64c3378ac2bcbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1a2a515500d7785418adeb60e61012a8179d4bb7f7aae88d4ae9e771bd4826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06221e569175ceb695d9477c6d741b72c4b90a3ef185dc72c2c47fd190fe5560"
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
