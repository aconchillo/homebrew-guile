class Haunt < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/haunt/haunt-0.3.0.tar.gz"
  sha256 "98babed06be54a066c3ebc94410a91eb7cc48367e94d528131d3ba271499992b"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/haunt-0.3.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3859831fcf91c4b82033dea7430194c2adb670b360c1e5b41ef0c846d10315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa4dc3c0d2655377cbf094cd22d566e87e8d7f0e9410e58cafe61fdbb29cfb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cad4b585f7ce82fa18c1c91719dd82daab1591a3d8790a8e51b7360012d3da7"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-commonmark"
  depends_on "guile-reader"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    haunt = testpath/"haunt.scm"
    haunt.write <<~EOS
      (use-modules (haunt site))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", haunt
  end
end
