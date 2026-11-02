class GuilePlotutils < Formula
  desc "Guile to use plotting and graphing functionality from GNU Plotutils"
  homepage "https://github.com/spk121/guile-plotutils"
  url "https://github.com/spk121/guile-plotutils/releases/download/v1.0.2/guile_plotutils-1.0.2.tar.gz"
  sha256 "37e389f058e97f8607ff26281e36b7ba94305cffa7b815ac9ccc315783147100"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-plotutils-1.0.2"
    sha256 cellar: :any, arm64_tahoe:   "ab35b35c886d260ff20fd2ce76e259018357c8de36de45e6f057bb4a62cbaaba"
    sha256 cellar: :any, arm64_sequoia: "2871cf46747fc689fc896d0bb44a1d187fccae575beb15c9a1b8e8282e0e949b"
    sha256 cellar: :any, x86_64_linux:  "9e8f732fd17f29566dfa96d87a6753cd34d2b3c1dcf75a3696cbca03b0d36487"
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

    system "./configure", "--prefix=#{prefix}", "--with-gnu-filesystem-hierarchy"
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
