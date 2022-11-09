class Wisp < Formula
  desc "OAuth module for Guile"
  homepage "https://www.draketo.de/software/wisp"
  url "https://hg.sr.ht/~arnebab/wisp/archive/v1.0.7.tar.gz"
  sha256 "641ebd1624987a9f2b6ec9966ccf333b0894599bd9edcf609426b294a6f87b49"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/wisp-1.0.7"
    sha256 cellar: :any_skip_relocation, monterey:     "de3587a0be8100d36209d17cb9d1304891ac8f85456d0555b75978a47f8e3f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f8c38d4727994ded058b9ce402b1ea7f630d5705f39b3f04ac4e7eeddd480807"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "guile"

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
    wisp = testpath/"wisp.w"
    wisp.write <<~EOS
      display "Hello Homebrew!"
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", "--language=wisp", wisp
  end
end
