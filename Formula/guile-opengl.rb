class GuileOpengl < Formula
  desc "Library providing access to the OpenGL graphics API from Guile"
  homepage "https://www.gnu.org/software/guile-opengl/"
  url "https://ftp.gnu.org/gnu/guile-opengl/guile-opengl-0.2.0.tar.gz"
  sha256 "b8f087ec28823d099fb842c3ba94104bb04fa9e708166487a471989e1c176c65"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-opengl-0.2.0"
    sha256 cellar: :any_skip_relocation, monterey:     "d4b54025d4f6506f7b38d56a560bed8bcf18c6047ec951f78acad706ad225f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f8ffb8de23d0f65937399630157b6eae318858830c127b5663ebb7b116c53850"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

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
    opengl = testpath/"opengl.scm"
    opengl.write <<~EOS
      (use-modules (gl))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", opengl
  end
end
