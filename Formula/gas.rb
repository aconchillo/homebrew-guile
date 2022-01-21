class Gas < Formula
  desc "Mac Scripting with GuileScript"
  homepage "https://github.com/aconchillo/gas"
  url "https://github.com/aconchillo/gas/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "912ca91ac4fc6b3b4957da838512738b18f14d91eb2f0e5f1d9e6fa74636fedb"

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
