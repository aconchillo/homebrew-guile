class GuileIcs < Formula
  desc "RFC5545 (iCalendar) format parser for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-ics"
  url "https://github.com/artyom-poptsov/guile-ics/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e2be21a68df4c30f4c0fd312a2c283a0c779e7bd4706529735d0127f89ac76cb"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ics-0.3.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "44999905ff02946ec4dd54e2693351a686d7e8b8309d73afceb5932c1d6ab181"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9d450af898154354c596c09a8b177b14eb5755bfc5eb7f93cfb70e9331661dd"
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
