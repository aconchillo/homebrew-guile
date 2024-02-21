class Haunt < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/haunt/haunt-0.3.0.tar.gz"
  sha256 "98babed06be54a066c3ebc94410a91eb7cc48367e94d528131d3ba271499992b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/haunt-0.2.6_1"
    sha256 cellar: :any_skip_relocation, big_sur:      "f81c048772ac3c52a6c9bc5e6279b371525c3d8b7f5608bd2c7428950e037d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4504b0bb959ec1d71307ee32039fb61c20bfea728e9334a8069784042db7a103"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
