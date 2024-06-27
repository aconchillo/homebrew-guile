class Skribilo < Formula
  desc "Ultimate Document Programming Framework"
  homepage "https://www.nongnu.org/skribilo/"
  url "https://download.savannah.nongnu.org/releases/skribilo/skribilo-0.9.5.tar.gz"
  sha256 "00826a21c4634fb0b410ee89eb48068c445d800825874654e3d53d5ca3f0bf09"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/skribilo-0.9.5_2"
    sha256 arm64_sonoma: "2a9879cd7a0c7fd7b8f8ceb4a6ea930a40545e989d5d09a9f416ad2a07cbce62"
    sha256 ventura:      "16213cbce72a6edf3d6a0c07ed2b50425f4d1233915338a7fbe8aa87cb9877a8"
    sha256 x86_64_linux: "b7a26767889cd2491cb00988ae78520a72243da5885ceaf87fb25cb12600709a"
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
