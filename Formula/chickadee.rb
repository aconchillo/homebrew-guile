class Chickadee < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.6.0.tar.gz"
  sha256 "2980c5f34b17838f9f513d581d8b311ea709213990ba88fe8ff9ac32d89464cb"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/chickadee-0.6.0"
    rebuild 1
    sha256 catalina: "b567f045b2e377e616c2cb8d13edc58ad8aa0ae6f8a6a8ffb2254e61929c48d3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"

    # Use Homebrew /usr/local/opt instead.
    inreplace buildpath/"chickadee/config.scm" do |s|
      s.gsub!(/^\(define %libopenal .*/,
              "(define %libopenal \"#{HOMEBREW_PREFIX}/opt/openal-soft/lib/libopenal\")")
      s.gsub!(/^\(define %libvorbisfile .*/,
              "(define %libvorbisfile \"#{HOMEBREW_PREFIX}/opt/libvorbis/lib/libvorbisfile\")")
      s.gsub!(/^\(define %libmpg123 .*/,
              "(define %libmpg123 \"#{HOMEBREW_PREFIX}/opt/mpg123/lib/libmpg123\")")
      s.gsub!(/^\(define %libfreetype .*/,
              "(define %libfreetype \"#{HOMEBREW_PREFIX}/opt/freetype/lib/libfreetype\")")
    end

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
