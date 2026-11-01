class GuileTermios < Formula
  desc "POSIX termios interface for GNU Guile"
  homepage "https://github.com/ft/guile-termios"
  url "https://github.com/ft/guile-termios/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "4e6751788ed8cb2ec8426da32e6bcfe68cc9f4fe34ce8a12d93ca289e33bbe1e"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-termios-0.6.4_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d8477ee9c08fdcd391eabde4187c406d07c1cca09e02fb1650bbdbd277d312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b3daa8dd6c0db9012bdbbc91a846c154c4a344116fe05b9a3300c3eb0257b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85226d57df33b7235f4a1807ed2dc8cc369d35d59e381ff0087e686a6f76247"
  end

  depends_on "guile"

  def install
    system "make", "-j1", "DESTDIR=#{prefix}", "PREFIX=/", "install"
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
    termios = testpath/"termios.scm"
    termios.write <<~EOS
      (use-modules (termios))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", termios
  end
end
