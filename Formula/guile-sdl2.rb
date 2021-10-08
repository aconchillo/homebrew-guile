class GuileSdl2 < Formula
  desc "Guile bindings for the SDL2 C shared library"
  homepage "https://dthompson.us/projects/guile-sdl2.html"
  url "https://files.dthompson.us/guile-sdl2/guile-sdl2-0.7.0.tar.gz"
  sha256 "874a2c09446761351016b2b0d22ec977e40223ca6247535413695bc4fbfceda4"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sdl2-0.6.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "c8c4639785f6b0f26b59054a61430e5fdde3113b9ff5fcefe23f5f9c0afb578e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd824207b4bdd32b8ed8e155933a7a4edaf66de27a0f29396ffce63bb0afea0c"
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
