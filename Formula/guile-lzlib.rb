class GuileLzlib < Formula
  desc "GNU Guile bindings to the lzlib compression library"
  homepage "https://codeberg.org/guile-compression/guile-lzlib"
  url "https://codeberg.org/guile-compression/guile-lzlib/archive/0.4.1.tar.gz"
  sha256 "760ebca527a668fa7fba18dbd0200df9d6816709fca54c1fc03862bde1866eba"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lzlib-0.0.2_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c3b1c0b42f180dc53dac01e925949f59775550b19d40d89a020922badce501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44cd8937d9b8cb4fdc56d309f6afbc7c06f9ac2a4ed3d0093cefd44e9354bf8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d9eb6b89f45df1e615ec55bacf385ef4f526da1a48bb7858827b2bb0d1c605"
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
