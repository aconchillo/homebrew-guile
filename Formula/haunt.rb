class Haunt < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/haunt/haunt-0.3.0.tar.gz"
  sha256 "98babed06be54a066c3ebc94410a91eb7cc48367e94d528131d3ba271499992b"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/haunt-0.3.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0b205f94fb650bb78688c7090ddfecc0c24fa4fd203153a264c2a40febc7db36"
    sha256 cellar: :any_skip_relocation, ventura:      "aaf9a6afd7b9dc42646a3c7df6fe57e5641d07860b20efbde3acb7e1222b2f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a64b835492291623e9664bb9b4e56f3e110aeec56f39a7e452ccb748162c5322"
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
