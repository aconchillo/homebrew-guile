class GuileZlib < Formula
  desc "GNU Guile bindings to the zlib compression library"
  homepage "https://notabug.org/guile-zlib/guile-zlib"
  url "https://notabug.org/guile-zlib/guile-zlib/archive/0.0.1.tar.gz"
  sha256 "f1100be6dd31b02983cf498155bf11155ca833421f99698f29e5694317335fb1"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zlib-0.0.1"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d01863c257278680b64d21d537390e79dea7cedfef6d4f5fe3df3153de69ee63" => :catalina
    sha256 "3aee22c6e91c77e58615a0a0c2ffa6b2911250b2702dae28387da564d11df9bb" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "zlib"

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
    zlib = testpath/"zlib.scm"
    zlib.write <<~EOS
      (use-modules (zlib))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zlib
  end
end
