class GuileXmlrpc < Formula
  desc "XMLRPC module for Guile"
  homepage "https://github.com/aconchillo/guile-xmlrpc"
  url "https://download.savannah.gnu.org/releases/guile-xmlrpc/guile-xmlrpc-0.4.0.tar.gz"
  sha256 "357755571b85a1e07d1caafdc63ad1c186913ec9ad94b44631df37c8abfc91ac"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-xmlrpc-0.4.0"
    cellar :any_skip_relocation
    sha256 "ad0f7bca8cb950a8bea0740ad630a7b0f11f93f8e09e6dcf90730ff79a2f0b30" => :catalina
    sha256 "e982a7d30d738772772be0d0d9db6af6163f86e88b06ad67d19e984ce4d3555f" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    xmlrpc = testpath/"xmlrpc.scm"
    xmlrpc.write <<~EOS
      (use-modules (xmlrpc))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", xmlrpc
  end
end
