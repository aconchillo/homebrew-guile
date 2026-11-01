class GuileSdl2 < Formula
  desc "Guile bindings for the SDL2 C shared library"
  homepage "https://dthompson.us/projects/guile-sdl2.html"
  url "https://files.dthompson.us/releases/guile-sdl2/guile-sdl2-0.8.0.tar.gz"
  sha256 "57f5eba45aea3b14b9980a61b48b767b77b07e52be1dd2c512a3a68b1f7ca7ec"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sdl2-0.8.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92a04faae739c9c0206e5c26940968eb97c9b13fb3fede24db3e05be48673d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a49264408ae16d9476e366e31033bf575702020f13b3692755bc9b1e56f065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf1bb314e7e2b2f2033d3507f4914b8ad83458ab5a1f179a0ef3505f5bcac2d0"
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

  post_install_steps do
    # Touch config.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/sdl2/config.go"
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
