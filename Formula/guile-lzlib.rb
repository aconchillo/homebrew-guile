class GuileLzlib < Formula
  desc "GNU Guile bindings to the lzlib compression library"
  homepage "https://notabug.org/guile-lzlib/guile-lzlib"
  url "https://notabug.org/guile-lzlib/guile-lzlib/archive/0.0.2.tar.gz"
  sha256 "8623db77d447e7b9ffbfcbc288390e706a6b1a89b1171daed60874cfec7e4f87"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzlib-0.0.2_1"
    sha256 cellar: :any_skip_relocation, monterey:     "a8c52cb03f92807a98baa578b1a93dbe2abab879aa2dd1c07a5796a37ca88e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d047552bfe0b67834a0ff2d21fe87e8fac031c00b0782d09d42923abc4afcc1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "lzlib"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/lzlib/config.go"
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
    lzlib = testpath/"lzlib.scm"
    lzlib.write <<~EOS
      (use-modules (lzlib))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", lzlib
  end
end
