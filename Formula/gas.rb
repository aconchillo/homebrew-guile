class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f32566e662b08a700e72c6f79d525914651d67d5be898f3109d91d52029c815d"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/gas-0.1.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "d6cbaefa6c1db66b6337810a9cb8810ffe56be2f1e5c8cf12f50d725a2d5c540"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4782b63507eb9d76cc656ff1e848f95f3f8cc5f3ae6c672b57b3760e2c5e0f2"
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
