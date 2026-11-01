class GuileNcurses < Formula
  desc "Guile library for creating text user interfaces with ncurses"
  homepage "https://www.gnu.org/software/guile-ncurses/"
  url "https://ftpmirror.gnu.org/guile-ncurses/guile-ncurses-3.1.tar.gz"
  sha256 "ee89e8ceafcab9dd0ef3fc1acc9b10f4d21ba4b256d329d842d6183e63f8d733"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ncurses-3.1_1"
    sha256 cellar: :any, arm64_tahoe:   "9eaf1c5f3056fce5aea0632cbe2b5a373f72087100c45bfcc53ed6b81983dfe3"
    sha256 cellar: :any, arm64_sequoia: "2450ea9a4dd01b3e8ea7a67b05bcb1c41f734dc5a951970141e6509c4201913f"
    sha256 cellar: :any, x86_64_linux:  "f0594930006e89cf340e8d412ad168d05fac560f15dd76e90f849ccc280f743b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libunistring"
  depends_on "ncurses"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"configure.ac",
              "guileextensiondir=\"$libdir/guile/$guile_effective_version\"",
              "guileextensiondir=\"$libdir/guile/$guile_effective_version/extensions\""
    inreplace "src/ncurses/extra_type.c", "#include <string.h>\n", "#include <string.h>\n#include <unistd.h>\n"
    # Newer ncurses makes ITEM opaque in curses.h, but menu_type.c unlinks
    # menu items directly, so expose the struct before including menu.h.
    inreplace "src/ncurses/menu_type.c", %r{#include <((?:ncursesw?/)?)menu\.h>},
              "#include <\\1curses.h>\n" \
              "#undef NCURSES_OPAQUE_MENU\n#define NCURSES_OPAQUE_MENU 0\n" \
              "#include <\\1menu.h>"

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
