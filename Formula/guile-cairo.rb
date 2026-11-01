class GuileCairo < Formula
  desc "Guile wrapper for the Cairo graphics library"
  homepage "https://www.nongnu.org/guile-cairo/"
  url "https://git.savannah.gnu.org/git/guile-cairo.git", revision: "74ce9a9696fa8d14ce15c27c4b0da8219f62403f"
  version "1.11.2"
  license "LGPL-3.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-cairo-1.11.2_3"
    sha256 arm64_tahoe:   "46b74f75a99c71166b189b1e207b91c7494c926c5755b2e40a53192586b6d3db"
    sha256 arm64_sequoia: "97d2224c699ec2d31fed307c2c9af118f99e6c8a61290d98e05a5cc305832c6f"
    sha256 x86_64_linux:  "9ffbbd71e9aa4e18e44044df316f3e7ea5fbbe8fe452e7f1957a246d96048676"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"
    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  post_install_steps do
    # Touch config.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/cairo/config.go"
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
    cairo = testpath/"cairo.scm"
    cairo.write <<~EOS
      (use-modules (cairo))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", cairo
  end
end
