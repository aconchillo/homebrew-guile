class GuileGoblins < Formula
  desc "Distributed object programming environment"
  homepage "https://gitlab.com/spritely/guile-goblins"
  url "https://files.spritely.institute/releases/guile-goblins/guile-goblins-0.18.0.tar.gz"
  sha256 "2ab81640e57d3e97e84a2d0a7310eb65dcf1475003f4f383a527e1ca5100453e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-goblins-0.18.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "777262718e987008d09132a13d9b8320e52f23fc6560942babcc772296244746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c93304db8b59d9ba76cb0564c08661aacf48737ae455a0eb8887cde011751c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6ecf60dbbe13dded545f56c959fc019aa4d82105f532bac0cfacac47d33658"
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
