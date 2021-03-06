class GuileOpengl < Formula
  desc "Library providing access to the OpenGL graphics API from Guile"
  homepage "https://www.gnu.org/software/guile-opengl/"
  url "https://ftp.gnu.org/gnu/guile-opengl/guile-opengl-0.1.0.tar.gz"
  sha256 "35d2b953052ccd7e41d2429bca71bca03d8f08a206a59d71f7592d043be90e8f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-opengl-0.1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "c3bc4dd42c51533cb4cc744b8c9193d6088433487a63066411d88ffe1767a4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ee8e1a240dab302e24a2df91fa677c143858231bfc62f89ce3a2a7c13849c7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"configure.ac", "2.2 2.0", "3.0"
    inreplace buildpath/"Makefile.am", "ccache", "site-ccache"

    system "autoreconf", "-vif"
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
