class GuileZstd < Formula
  desc "GNU Guile bindings to the zstd compression library"
  homepage "https://notabug.org/guile-zstd/guile-zstd"
  url "https://notabug.org/guile-zstd/guile-zstd/archive/v0.1.1.tar.gz"
  sha256 "6e57ef524f20cab79ca5fd62366c5435f71cf652f582fc1e7d62585e90d499c5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zstd-0.1.1"
    sha256 "fe5556b11ce2be358f7513a889e478cf8f509bed560d24379479bd0ad3b6849a" => :catalina
    sha256 "3c4421053b47bd93d0fed69d1998a434967cf6057c3e5c660ffcefae91578918" => :x86_64_linux
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
      (use-modules (srfi srfi-1))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zstd
  end
end