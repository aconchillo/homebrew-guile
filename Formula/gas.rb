class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f32566e662b08a700e72c6f79d525914651d67d5be898f3109d91d52029c815d"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/gas-0.1.0_1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "35a12a10398be6660f1949dfe898a5226ae7ad24b3b0cd0f15e1d1f367565551"
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
