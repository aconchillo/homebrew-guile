class Chickadee < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.7.0.tar.gz"
  sha256 "e6b2268f2af89028d23d5cee6caf4e7d1fe8344a09a6a01d9d466d24d8243ea5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/chickadee-0.7.0"
    sha256 catalina:     "315325ef8f4da430c8462c245fb99a36dcaa3e51861aeeeeac17c51bd98569bc"
    sha256 x86_64_linux: "32978d854a9d544b81c4b86b2b631cbb0afb96a665ef79dcd37c97c049a9a652"
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
