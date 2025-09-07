class Fibers < Formula
  desc "Concurrency library for Guile"
  homepage "https://codeberg.org/fibers/fibers"
  url "https://codeberg.org/fibers/fibers/archive/v1.4.0.tar.gz"
  sha256 "2b9fa0bf3009111678a82343b8847aa0eed72dd9d1516fece7bc8274893a40c4"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/fibers-1.4.0"
    sha256 arm64_sequoia: "3f36d0ec5f45525278e8cdf8dd725299da0d8702bce35f0f7109ca5256ec89bc"
    sha256 arm64_sonoma:  "3c1ed2697d8088bfb0b4110a6c6c69ebe727765644316a117cd9285903cda1de"
    sha256 ventura:       "0cb2800651d443c56a180a4f9f1d4b3a36055b0149d4c1b26d366d47860db6ae"
    sha256 x86_64_linux:  "d55c795a3b457786ba566507fc58551953f68457e039e150baa282a8d305f83a"
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
