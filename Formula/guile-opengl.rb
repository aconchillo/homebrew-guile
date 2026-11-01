class GuileOpengl < Formula
  desc "Library providing access to the OpenGL graphics API from Guile"
  homepage "https://www.gnu.org/software/guile-opengl/"
  url "https://ftpmirror.gnu.org/guile-opengl/guile-opengl-0.2.0.tar.gz"
  sha256 "b8f087ec28823d099fb842c3ba94104bb04fa9e708166487a471989e1c176c65"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-opengl-0.2.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c610941f7b0bff002c6ccb9a649c068993c224b32ace73b81a74c7539b3c712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d18f4e154b289051d911f98a374c9d002793def87f3c04bfcbe649179b4e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ba8bd61d2613421e6eee47a9e68d82d791e340716eb14d205570a5984eadb4"
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
