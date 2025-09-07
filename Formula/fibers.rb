class Fibers < Formula
  desc "Concurrency library for Guile"
  homepage "https://codeberg.org/fibers/fibers"
  url "https://codeberg.org/fibers/fibers/archive/v1.4.0.tar.gz"
  sha256 "2b9fa0bf3009111678a82343b8847aa0eed72dd9d1516fece7bc8274893a40c4"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/fibers-1.3.1_2"
    sha256 arm64_sonoma: "793e62769b2d66f05023b1face31289c5edfcde2b319c39b151fcbff66392330"
    sha256 ventura:      "06e1638a1bf6573e3896916102b833de7089b5cbfd666fe5ad319dd2d35fb38e"
    sha256 x86_64_linux: "a0808b2e2e9d6b46008fb0426aada2c5c43cd89c229513621070f86da6c026b7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libevent"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./autogen.sh"
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
    fibers = testpath/"fibers.scm"
    fibers.write <<~EOS
      (use-modules (fibers))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", fibers
  end
end
