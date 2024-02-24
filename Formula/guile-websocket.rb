class GuileWebsocket < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/guile-websocket.html"
  url "https://files.dthompson.us/guile-websocket/guile-websocket-0.1.tar.gz"
  sha256 "2441d36470b6264331f124ca09ca754ffeedac77b801444cfbe6b18950e05074"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-websocket-0.1_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "28d5cc28b0eb270f2820308af7b41ca8e9e3f1233951093bc850d359335e9a02"
    sha256 cellar: :any_skip_relocation, ventura:      "ee2ab43fffd0ff3d479f4c0396b5ffacb9c611f39ad0220b3a6f5d176e904fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "47751ffc34750e8cb8a305dbaa15e9efd56073b38698121619b4dbb8584c2dc4"
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
