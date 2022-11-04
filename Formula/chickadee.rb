class Chickadee < Formula
  desc "Game development toolkit for Guile"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.9.0.tar.gz"
  sha256 "733bc907c0a5d33f77198bab365fd1072657376a6f1382774dc2c8791aa5222d"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/chickadee-0.8.0_3"
    sha256 big_sur:      "b7bbd07d68730f788e6cce754b23649ffe16c6bab57d3c08de863a96f4c90fde"
    sha256 x86_64_linux: "5f48f4fe700ab42a74125e28163fdba4729939a30fdac8116a3f423bc9ee2902"
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
