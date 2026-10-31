class GuileWebsocket < Formula
  desc "Implementation of the WebSocket protocol as defined by RFC 6455"
  homepage "https://dthompson.us/projects/guile-websocket.html"
  url "https://files.dthompson.dev/guile-websocket/guile-websocket-0.3.0.tar.gz"
  sha256 "1ba6c0d1d175f4a68b58ce003257477e3931fea0d70593881aa7177cb99483fc"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-websocket-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b42c94caf9efb3e3734a4baab56fe007c16d75c6acc6f0c65f228ab9a66be80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca6db794bbb30061e03da452d60cb2e35d98e55e9ed8c59d20aea79a45fda65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd6632a4ad1b4ba3272107b9019713fc80440041d51788bb5d6e396006ba733"
  end

  depends_on "guile"
  depends_on "guile-gnutls"

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
    websocket = testpath/"websocket.scm"
    websocket.write <<~EOS
      (use-modules (web socket client) (web socket server))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", websocket
  end
end
