class GuileWebsocket < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/guile-websocket.html"
  url "https://files.dthompson.us/guile-websocket/guile-websocket-0.1.tar.gz"
  sha256 "2441d36470b6264331f124ca09ca754ffeedac77b801444cfbe6b18950e05074"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-websocket-0.1"
    sha256 cellar: :any_skip_relocation, monterey:     "fdf02a6044a12dc9607267b35dcb027959530ea008b6aa86ce6afc96d804527f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd507c47e74cff3f0dd65e3e0d03408e8c51673f1d503689629e4c5d8735cfde"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
