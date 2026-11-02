class Skribilo < Formula
  desc "Ultimate Document Programming Framework"
  homepage "https://www.nongnu.org/skribilo/"
  url "https://download.savannah.nongnu.org/releases/skribilo/skribilo-0.11.1.tar.gz"
  sha256 "665c241c42920bf369f1231d4b9c71ce18ba63add0b9a8f241821fd11a28d592"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/skribilo-0.11.1"
    sha256 arm64_tahoe:   "59a5eebf508cfff16aa506ce92918dd1b9e07509df807a8135ea156ba36984e7"
    sha256 arm64_sequoia: "3c6bafbfd00fceaa358a29cd8369ce8772768be0d8dd64f33fd03d45b49410bb"
    sha256 x86_64_linux:  "d44b7d7fb78744ebcac01d56bb19d72579274e31ffdf25a8caae02032fae1589"
  end

  depends_on "gnu-sed" => :build
  depends_on "aconchillo/guile/ploticus"
  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-reader"
  depends_on "imagemagick"
  depends_on "lout"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    ENV["PATH"] = "#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:#{ENV["PATH"]}"

    system "./configure",
           "--prefix=#{prefix}",
           "--with-lispdir=#{share}/emacs/site-lisp/skribilo"
    system "make", "install"
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
    skribilo = testpath/"skribilo.scm"
    skribilo.write <<~EOS
      (use-modules (skribilo engine))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", skribilo
  end
end
