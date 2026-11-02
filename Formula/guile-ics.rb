class GuileIcs < Formula
  desc "RFC5545 (iCalendar) format parser for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-ics"
  url "https://github.com/artyom-poptsov/guile-ics/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ac2002c5c2e875511c9a289dcc6fe6749321494c7d8154d1d47e7e135bd625ed"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ics-0.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32500627c635d19030fb43654986e172d369ebe0d9594217c6ada7a1a84a4423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4103247bec44f38e3e93899cca56b6660d2bce2c62ef6ca1e82862d3043bf236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d35e3b58c8f32f44848119d93108814c3cd254f3e4824746ae666407e3bac2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because of install not working great on macOS 10.11. coreutils
  # will bring ginstall.
  depends_on "coreutils" => :build
  depends_on "gettext" => :build
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

    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"
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
