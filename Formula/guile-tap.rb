class GuileTap < Formula
  desc "Test Framework that emits TAP output for GNU Guile"
  homepage "https://github.com/ft/guile-tap"
  url "https://github.com/ft/guile-tap/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "07e44d1a597b21fe6f2e0ec012e196da0b61dea7066e59a0fd93c62a5dcad575"

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
