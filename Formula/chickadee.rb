class Chickadee < Formula
  desc "Game development toolkit for Guile"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.10.0.tar.gz"
  sha256 "132f53b6e59a1a51c6d9c618c2a248b76457ed73545b6f0e1a5fe4b8f5020f75"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/chickadee-0.10.0_2"
    sha256 arm64_sonoma: "799bbb4456a19556444898ba2d918e1019619bfc19c4883b0b47e48eb4c4e708"
    sha256 ventura:      "23ebf170b9df5a94f2d7ba4bf820ae003ac93e7fb3100099ca41831fa85e9717"
    sha256 x86_64_linux: "807c3bf17f682df29bad662b8ebed5b1f77ac634bfc32e456b41f410d9baec49"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-opengl"
  depends_on "guile-sdl2"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "openal-soft"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./configure", "--prefix=#{prefix}"

    # Use Homebrew prefix instead instead.
    inreplace buildpath/"chickadee/config.scm" do |s|
      s.gsub!(%r{".*/libpng"}, "\"#{HOMEBREW_PREFIX}/opt/libpng/lib/libpng\"")
      s.gsub!(%r{".*/libturbojpeg"}, "\"#{HOMEBREW_PREFIX}/opt/jpeg-turbo/lib/libturbojpeg\"")
      s.gsub!(%r{".*/libopenal"}, "\"#{HOMEBREW_PREFIX}/opt/openal-soft/lib/libopenal\"")
      s.gsub!(%r{".*/libvorbisfile"}, "\"#{HOMEBREW_PREFIX}/opt/libvorbis/lib/libvorbisfile\"")
      s.gsub!(%r{".*/libmpg123"}, "\"#{HOMEBREW_PREFIX}/opt/mpg123/lib/libmpg123\"")
      s.gsub!(%r{".*/libfreetype"}, "\"#{HOMEBREW_PREFIX}/opt/freetype/lib/libfreetype\"")
      s.gsub!(%r{".*/libreadline"}, "\"#{HOMEBREW_PREFIX}/opt/readline/lib/libreadline\"")
    end

    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/chickadee/config.go"
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
    chickadee = testpath/"chickadee.scm"
    chickadee.write <<~EOS
      (use-modules (chickadee))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", chickadee
  end
end
