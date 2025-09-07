class GuileGoblins < Formula
  desc "Distributed object programming environment"
  homepage "https://gitlab.com/spritely/guile-goblins"
  url "https://files.spritely.institute/releases/guile-goblins/guile-goblins-0.16.1.tar.gz"
  sha256 "30bb8271aaf0aa046dc6c30e341b2f7efacbcf7d0a17aced2d60328b526ece81"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-goblins-0.16.1_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74aafe763c439335a504faedb4f17c27017ee1459ddf066257e8418a05d482d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44bb4fea5acf560b6958eaf7e8f128529849f2ca3d0888f5e5d8e4d05ee9aa55"
    sha256 cellar: :any_skip_relocation, ventura:       "d70d53d84b1f579e7148b734dbf7d2497d388e78db3f7f29103e4b0ba045ffe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5216549a210c81b7941bc551dcf6b5bc671ccb1ea596e2676a01ed0e20fb5c48"
  end

  depends_on "texinfo" => :build
  depends_on "fibers"
  depends_on "guile"
  depends_on "guile-gcrypt"
  depends_on "guile-gnutls"
  depends_on "guile-websocket"

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
    goblins = testpath/"goblins.scm"
    goblins.write <<~EOS
      (use-modules (goblins))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", goblins
  end
end
