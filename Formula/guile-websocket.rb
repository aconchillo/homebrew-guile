class GuileWebsocket < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/guile-websocket.html"
  url "https://files.dthompson.us/guile-websocket/guile-websocket-0.2.0.tar.gz"
  sha256 "ee3c63f88e56a6ab46bbdf73af397dd9e219513872ebd0380ac2f35e7a787690"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-websocket-0.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b35d0e60d58a52ac10c3762ad5568f17ffd1e35a21cf026599674a5318932138"
    sha256 cellar: :any_skip_relocation, ventura:      "19ca2ae20365728f371c5b30130a32d057f623f8146ac6933c99884db30428e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ef877bc13624d1abd8ed68f95cc6d4c575462f7e973afc8234d16a4dd238e011"
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
