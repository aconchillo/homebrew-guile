class GuileGoblins < Formula
  desc "Distributed object programming environment"
  homepage "https://gitlab.com/spritely/guile-goblins"
  url "https://spritely.institute/files/releases/guile-goblins/guile-goblins-0.10.tar.gz"
  sha256 "a2f52decdc51484a912d029b713ab4d70261e6b8404f616b3e42824a22afdf8e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-goblins-0.8"
    sha256 cellar: :any_skip_relocation, monterey:     "ba6c0c22e09cd91874bc69edae1afd6c8466a4f2f2c8460fd77c034d0eb21d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9b609a34187ae62cdca14ea46e7ccb5bc3b988ce1cd1cf9d0974f74d44c519c4"
  end

  depends_on "texinfo" => :build
  depends_on "fibers"
  depends_on "guile"
  depends_on "guile-gcrypt"

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
