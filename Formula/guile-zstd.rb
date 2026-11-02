class GuileZstd < Formula
  desc "GNU Guile bindings to the zstd compression library"
  homepage "https://codeberg.org/guile-compression/guile-zstd"
  url "https://codeberg.org/guile-compression/guile-zstd/archive/v0.1.2.tar.gz"
  sha256 "ca882f15ecf070f9226434d78d0e7bfc9291c21d31a49514f620ede59b2f7cc0"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zstd-0.1.2"
    sha256 arm64_tahoe:   "e9f1a3580000f65354e05fe018aacf1916e7c9974517dfde5a00984696fe832c"
    sha256 arm64_sequoia: "adbdaae0c34f6064cf1edb40856501106952aa9716b78925bcef2f8ba232fd33"
    sha256 x86_64_linux:  "b91f4cb1da31ecdd608ba73b67731ff943646ca2f733f82f6c83d20af95c96a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "zstd"

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
    zstd = testpath/"zstd.scm"
    zstd.write <<~EOS
      (use-modules (zstd))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zstd
  end
end
