class GuileZlib < Formula
  desc "GNU Guile bindings to the zlib compression library"
  homepage "https://codeberg.org/guile-compression/guile-zlib"
  url "https://codeberg.org/guile-compression/guile-zlib/archive/v0.2.2.tar.gz"
  sha256 "6f6cca4b32ca79f3f4627cdb7ea68569a3cc38be60468991e2b5c085783e38c1"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zlib-0.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a354af33569afb223d9203121e2acc7c2174a766a9f60b83f7262d266d13e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8454b44842a270a027e31e130c523463e1b1c3af663fb3dc8f0e7ec27f99037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46af0c818b0909ab48e38bbbb9dd5a4334b9f89181cf91f0de6b6ff6a6282753"
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
