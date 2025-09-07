class GuileOpengl < Formula
  desc "Library providing access to the OpenGL graphics API from Guile"
  homepage "https://www.gnu.org/software/guile-opengl/"
  url "https://ftpmirror.gnu.org/gnu/gnu/guile-opengl/guile-opengl-0.2.0.tar.gz"
  sha256 "b8f087ec28823d099fb842c3ba94104bb04fa9e708166487a471989e1c176c65"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-opengl-0.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "98e89fdeeb2e7177ae9eb2e970ad57e5eb7613327d399e157d222d42e5f71e10"
    sha256 cellar: :any_skip_relocation, ventura:      "36894c3b06e6914af2caaf4777255708b8da2c37455a6c8fb3cb1ae9014d776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b9f115cf007e5657649c03b05541e3bf47a35c4e907d96f5e36ac75f48aa4c4"
  end

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
