class GuileDsv < Formula
  desc "Guile module for delimiter-separated values (DSV) data format"
  homepage "https://github.com/artyom-poptsov/guile-dsv"
  url "https://github.com/artyom-poptsov/guile-dsv/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "49cc236d58b9bfb35c795e4a62b0a9cb337ff1880d1d52202ca757d8354d785e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dsv-0.7.2"
    sha256 arm64_sonoma: "198c768804e090beb274382885d64d712a6650015d17e98bff639b5e3f56b715"
    sha256 ventura:      "6c7816a07e7bf34278f9a70e0d9b5e4181d93abd83848d62099620fb803f7bf2"
    sha256 x86_64_linux: "6eb0315697c58766c34fdd1cfb5b84725c05961088c7724468a9501c5b8a41c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "help2man"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    dsv = testpath/"dsv.scm"
    dsv.write <<~EOS
      (use-modules (dsv))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dsv
  end
end
