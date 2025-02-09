class GuileGoblins < Formula
  desc "Distributed object programming environment"
  homepage "https://gitlab.com/spritely/guile-goblins"
  url "https://spritely.institute/files/releases/guile-goblins/guile-goblins-0.15.0.tar.gz"
  sha256 "1f89819f415edf627df69c9b7daee331fc4106f9937df7db01c721ba3b82ddb7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-goblins-0.14.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a26d339d86a57e28f5e00e9eb2d8c8a208053c75faccc709c9fd48181e5494a1"
    sha256 cellar: :any_skip_relocation, ventura:      "2e717086b4accbbacc8b6dd0b942e710f5867602751c64438c6e4f37efc2c933"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "42dfa972cb1e356fb2c72feecb770666a289eb30c40382eae1f40335e97a1109"
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
