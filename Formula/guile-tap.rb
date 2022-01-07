class GuileTap < Formula
  desc "Test Framework that emits TAP output for GNU Guile"
  homepage "https://github.com/ft/guile-tap"
  url "https://github.com/ft/guile-tap/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "b01f64a68e78d8a5149f0d706cc3215a1374b1c226fcf200cd0d6b432d0b964c"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-tap-0.4.6"
    sha256 cellar: :any_skip_relocation, big_sur:      "c62b5c309e28ad17f891436bc6a0c89fab637d4241c4e2ed7ebe0a28bed42bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1573e71239176b1903e57abc8c10f818b483d14b4781d86117b39f3fb7c1778f"
  end

  depends_on "guile"

  def install
    inreplace buildpath/"bin/tap-harness", "/usr/bin", "#{HOMEBREW_PREFIX}/bin"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
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
    tap = testpath/"tap.scm"
    tap.write <<~EOS
      (use-modules (test tap))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", tap
  end
end
