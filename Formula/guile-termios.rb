class GuileTermios < Formula
  desc "POSIX termios interface for GNU Guile"
  homepage "https://github.com/ft/guile-termios"
  url "https://github.com/ft/guile-termios/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "4e6751788ed8cb2ec8426da32e6bcfe68cc9f4fe34ce8a12d93ca289e33bbe1e"

  depends_on "guile"

  def install
    system "make", "-j1", "DESTDIR=#{prefix}", "PREFIX=/", "install"
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
    termios = testpath/"termios.scm"
    termios.write <<~EOS
      (use-modules (termios))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", termios
  end
end
