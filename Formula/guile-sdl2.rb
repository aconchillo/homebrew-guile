class GuileSdl2 < Formula
  desc "Guile bindings for the SDL2 C shared library"
  homepage "https://dthompson.us/projects/guile-sdl2.html"
  url "https://files.dthompson.us/guile-sdl2/guile-sdl2-0.8.0.tar.gz"
  sha256 "57f5eba45aea3b14b9980a61b48b767b77b07e52be1dd2c512a3a68b1f7ca7ec"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sdl2-0.7.0_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "2fd80c5365d556a76ac0466317046062d933e34caa4e460abcd8c72afede2304"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dda288eafe8decabf79089e4cee2c13c33f35096d33758cdeeeabd6812378bed"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/sdl2/config.go"
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
    sdl2 = testpath/"sdl2.scm"
    sdl2.write <<~EOS
      (use-modules (sdl2))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", sdl2
  end
end
