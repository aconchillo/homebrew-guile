class GuilePlotutils < Formula
  desc "Guile to use plotting and graphing functionality from GNU Plotutils"
  homepage "https://github.com/spk121/guile-plotutils"
  url "https://github.com/spk121/guile-plotutils/releases/download/v1.0.1/guile_plotutils-1.0.1.tar.gz"
  sha256 "d93068400bb5fbaf73ef4afd3fd22104cbec6d25e85f774afcef3756ce2f4464"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-plotutils-1.0.1_1"
    sha256 cellar: :any,                 monterey:     "c8d899bdd3719523ad0e54a159a0c6dc9ce8110b11ce002fb53b4770df9de01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ddc0a4f76b778363c9d449e53deeaa0f1070c65bc5b9083c68750e750639d188"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "plotutils"

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
    plotutils = testpath/"plotutils.scm"
    plotutils.write <<~EOS
      (use-modules (plotutils graph))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", plotutils
  end
end
