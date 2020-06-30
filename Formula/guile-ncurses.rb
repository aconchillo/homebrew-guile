class GuileNcurses < Formula
  desc "Guile library for creating text user interfaces with ncurses"
  homepage "https://www.gnu.org/software/guile-ncurses/"
  url "https://ftp.gnu.org/gnu/guile-ncurses/guile-ncurses-3.0.tar.gz"
  sha256 "0e4a9eef7237aeef6cc9e5e1fa8513bfd328e971efd74d8d78d543aa9c5b1d0d"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "ncurses"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"configure.ac",
              "guileextensiondir=\"$libdir/guile/$guile_effective_version\"",
              "guileextensiondir=\"$libdir/guile/$guile_effective_version/extensions\""

    system "autoreconf", "-vif"
    system "./configure",
           "--prefix=#{prefix}",
           "--with-gnu-filesystem-hierarchy"
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
    ncurses = testpath/"ncurses.scm"
    ncurses.write <<~EOS
      (use-modules (ncurses curses))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ncurses
  end
end
