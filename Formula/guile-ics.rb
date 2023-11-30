class GuileIcs < Formula
  desc "RFC5545 (iCalendar) format parser for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-ics"
  url "https://github.com/artyom-poptsov/guile-ics/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3f4d8deca5ca13ae4927dd4866092b4375b01cf1300fc93fafc98a28e8ce7de6"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ics-0.5.0"
    sha256 cellar: :any_skip_relocation, monterey:     "7478f502ccc402e2bf4eecaac2e1fd8035d0cd2766d22ec6ec6307b3cb8110db"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e5fd89396705b6488e83ca6c0b9b8cd686d879c73ac38b4dec042647e828ad0a"
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
