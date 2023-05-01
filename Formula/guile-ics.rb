class GuileIcs < Formula
  desc "RFC5545 (iCalendar) format parser for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-ics"
  url "https://github.com/artyom-poptsov/guile-ics/archive/v0.5.0.tar.gz"
  sha256 "3f4d8deca5ca13ae4927dd4866092b4375b01cf1300fc93fafc98a28e8ce7de6"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ics-0.4.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "2193c06561588d4cff4a7ca0780d0bcda586b850a6125e736a1c6aff2d6ec9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f805c4f8a568fd39902429db8f6f61523dc6a8be79a2574223b185249720919d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because of install not working great on macOS 10.11. coreutils
  # will bring ginstall.
  depends_on "coreutils" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-smc"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
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
    ics = testpath/"ics.scm"
    ics.write <<~EOS
      (use-modules (ics))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ics
  end
end
