class GuileWebsocket < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/guile-websocket.html"
  url "https://files.dthompson.us/guile-websocket/guile-websocket-0.1.tar.gz"
  sha256 "2441d36470b6264331f124ca09ca754ffeedac77b801444cfbe6b18950e05074"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-websocket-0.1_1"
    sha256 cellar: :any_skip_relocation, monterey:     "cdd46942c05196ea0e75b729db750bd84aabe0eb5066e3a516f2e3b569628be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b879b6774eef465590472835ea9f20be65604004456be7416f1b60fcc1dc8f3f"
  end

  depends_on "guile"

  def install
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
