class GuileNcurses < Formula
  desc "Guile library for creating text user interfaces with ncurses"
  homepage "https://www.gnu.org/software/guile-ncurses/"
  url "https://ftpmirror.gnu.org/gnu/gnu/guile-ncurses/guile-ncurses-3.1.tar.gz"
  sha256 "ee89e8ceafcab9dd0ef3fc1acc9b10f4d21ba4b256d329d842d6183e63f8d733"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ncurses-3.1"
    sha256 cellar: :any,                 monterey:     "105aae7af1c856f39b443b18f39ba8b3ef75ae48f4d66df77639d81630cb7e0f"
    sha256 cellar: :any,                 big_sur:      "172734e20ce3d79734c282c504a07922f6d04a46b0a4707c3ffdc5385c6c326d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a357082632aaafe0b7721cb643f6f7fd5acd6ecd865b1de9d6ee05f75d458bb"
  end

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
