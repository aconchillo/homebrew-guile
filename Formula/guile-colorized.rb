class GuileColorized < Formula
  desc "Colorized REPL for GNU Guile"
  homepage "https://gitlab.com/NalaGinrut/guile-colorized"
  url "https://gitlab.com/NalaGinrut/guile-colorized/-/archive/v0.1/guile-colorized-v0.1.tar.gz"
  sha256 "fb60ca552f6e935b9d8b6a7cf9b2a4e1c85caa6b5bce53f6f4541acf21c5ab47"

  bottle :unneeded

  depends_on "guile"

  def install
    inreplace buildpath/"Makefile", "$(TARGET)", "$(DESTDIR)/share/guile/site/3.0/ice-9/"

    mkdir "#{share}/guile/site/3.0/ice-9/"

    system "make", "DESTDIR=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"

      To enable colors on your Guile REPL add the following to your ~/.guile:
        (use-modules (ice-9 colorized))
        (activate-colorized)
    EOS
  end

  test do
    colorized = testpath/"colorized.scm"
    colorized.write <<~EOS
      (use-modules (ice-9 colorized))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", colorized
  end
end
