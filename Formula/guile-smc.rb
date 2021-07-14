class GuileSmc < Formula
  desc "GNU Guile state machine compiler"
  homepage "https://github.com/artyom-poptsov/guile-smc"
  url "https://github.com/artyom-poptsov/guile-smc/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dc4df6d07886538ae88c1fc2397580c79aac93f4f80435649d903665efcf5b78"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-smc-0.2.0"
    sha256 cellar: :any_skip_relocation, catalina:     "0d56430d3f37250c4c5fe036e7a562edd4d9b2a75471749a50b77a54bafd792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "47452c6617bf1621af04300d977c1e9c238e6edd96e537539134db2f4a3dd6ca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    system "autoreconf", "-vif"
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
    smc = testpath/"smc.scm"
    smc.write <<~EOS
      (use-modules (smc fsm))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", smc
  end
end
