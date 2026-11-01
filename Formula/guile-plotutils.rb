class GuilePlotutils < Formula
  desc "Guile to use plotting and graphing functionality from GNU Plotutils"
  homepage "https://github.com/spk121/guile-plotutils"
  url "https://github.com/spk121/guile-plotutils/releases/download/v1.0.1/guile_plotutils-1.0.1.tar.gz"
  sha256 "d93068400bb5fbaf73ef4afd3fd22104cbec6d25e85f774afcef3756ce2f4464"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-plotutils-1.0.1_3"
    sha256 cellar: :any, arm64_tahoe:   "0b64ea66b6f8ee14a19bcccfc1d9a61726b2d350d5b9f9bdedc2674c773807fe"
    sha256 cellar: :any, arm64_sequoia: "dff096ac9c68577cf97da8380df895ea9bb537159f98e15931592ece163f5fc8"
    sha256 cellar: :any, x86_64_linux:  "32cc5c4871d74c14c84485eebc438d090af6c3024dcbdce55be2558afb46e1c0"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "plotutils"

  on_macos do
    depends_on "bdw-gc"
  end

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
