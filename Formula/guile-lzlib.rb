class GuileLzlib < Formula
  desc "GNU Guile bindings to the lzlib compression library"
  homepage "https://notabug.org/guile-lzlib/guile-lzlib"
  url "https://notabug.org/guile-lzlib/guile-lzlib/archive/0.0.2.tar.gz"
  sha256 "8623db77d447e7b9ffbfcbc288390e706a6b1a89b1171daed60874cfec7e4f87"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzlib-0.0.2"
    sha256 cellar: :any_skip_relocation, catalina:     "8643b1c4cfd70c5f71d5d2fa3d9f4c5acb931380abef09de746bf2e8d98a2c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0ee6f3261221cd5f444fa7f553d49cf2ca84b3618d2fc743105eba9ba07e8935"
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
