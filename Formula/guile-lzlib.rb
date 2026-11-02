class GuileLzlib < Formula
  desc "GNU Guile bindings to the lzlib compression library"
  homepage "https://codeberg.org/guile-compression/guile-lzlib"
  url "https://codeberg.org/guile-compression/guile-lzlib/archive/0.4.1.tar.gz"
  sha256 "760ebca527a668fa7fba18dbd0200df9d6816709fca54c1fc03862bde1866eba"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzlib-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3cd3ed471f0d24568618e2f761c05245a4cf331d7be1c777c4c71f4ad1b3f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08f178f2460764b9769fd46ddd0111d228537edf4b33536c2383a438ac78a394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ffa7d9d1aeb6ecdeed79d23912a560d1ff0ad88b851b330d3c32e89623e9f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "lzlib"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  post_install_steps do
    # Touch config.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/lzlib/config.go"
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
    lzlib = testpath/"lzlib.scm"
    lzlib.write <<~EOS
      (use-modules (lzlib))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", lzlib
  end
end
