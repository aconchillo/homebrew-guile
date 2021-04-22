class Skribilo < Formula
  desc "Ultimate Document Programming Framework"
  homepage "https://www.nongnu.org/skribilo/"
  url "https://download.savannah.nongnu.org/releases/skribilo/skribilo-0.9.5.tar.gz"
  sha256 "00826a21c4634fb0b410ee89eb48068c445d800825874654e3d53d5ca3f0bf09"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/skribilo-0.9.5"
    rebuild 2
    sha256 catalina: "dfdb70de87335020289b3d6009cca1fe32a26a648882e66d1f8be5d001d43dc8"
  end

  depends_on "gnu-sed" => :build
  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-reader"
  depends_on "imagemagick"
  depends_on "lout"
  depends_on "ploticus"

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
