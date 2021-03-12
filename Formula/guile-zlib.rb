class GuileZlib < Formula
  desc "GNU Guile bindings to the zlib compression library"
  homepage "https://notabug.org/guile-zlib/guile-zlib"
  url "https://notabug.org/guile-zlib/guile-zlib/archive/v0.1.0.tar.gz"
  sha256 "25c726b570a06d21bc6fd7ec6093f377c749ce2efdd1d1516ac1b595f3f94ee9"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zlib-0.1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "2df67de39ed217c71c5bd7195a7a1b295489c8afe7fc75b691faa20f81d7e84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4eba8d7242afcf58842678696d91f92fbc2a938aeae24262e5a0c2ad7fe75ba6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "zlib"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    zlib = testpath/"zlib.scm"
    zlib.write <<~EOS
      (use-modules (zlib))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zlib
  end
end
