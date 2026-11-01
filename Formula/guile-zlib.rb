class GuileZlib < Formula
  desc "GNU Guile bindings to the zlib compression library"
  homepage "https://codeberg.org/guile-compression/guile-zlib"
  url "https://codeberg.org/guile-compression/guile-zlib/archive/v0.1.0.tar.gz"
  sha256 "25c726b570a06d21bc6fd7ec6093f377c749ce2efdd1d1516ac1b595f3f94ee9"
  revision 4

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zlib-0.1.0_4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc4e1ca3baed58573cd3c66cca7c754c661a4ad2ed5f5831e852c91335076085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aef300a762bcea6610fa324aeff49ef6f2bdb52c57f02296e67bb8bcd3cd363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787f337d8dadea49b3577157600707fd1510f345112f5729d793a1895d4f9d6a"
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

  post_install_steps do
    # Touch config.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/zlib/config.go"
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
