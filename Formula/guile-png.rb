class GuilePng < Formula
  desc "Portable Network Graphics library for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-png"
  url "https://github.com/artyom-poptsov/guile-png/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "11de1e5c5c608f486c7790970e21c0a09b849a60dbb1adaaba8434119968f50f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-png-0.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82550eb2e5c914f22d43391758a3df03711dd0523090221ae00846e48e482197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cffb843ba78b2fedda54bfdb3f7553e8dec450de6d3e47b309ca96b0bc41c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3729e700baf2e7a0a7703a648de23cf6a4b2f6fa31afae11b347bfdcd0e896"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "guile-zlib"

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
    png = testpath/"png.scm"
    png.write <<~EOS
      (use-modules (png) (png image))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", png
  end
end
