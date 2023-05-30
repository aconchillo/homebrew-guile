class Fibers < Formula
  desc "Concurrency library for Guile"
  homepage "https://github.com/wingo/fibers"
  url "https://github.com/wingo/fibers/releases/download/v1.3.1/fibers-1.3.1.tar.gz"
  sha256 "a5e1a9c49c0efe7ac6f355662041430d4b64e59baa538d2b8fb5ef7528d81dbf"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/fibers-1.2.0"
    sha256 monterey:     "bbf040fe738a48759e26d5478ec9704bb7f3680a032700add8adbdd047b0c78d"
    sha256 x86_64_linux: "4b8b111dd69dc1d259b1c8b201e42107d3c583cd65dcc92434dea7e78f3f1dff"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libevent"

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
    fibers = testpath/"fibers.scm"
    fibers.write <<~EOS
      (use-modules (fibers))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", fibers
  end
end
