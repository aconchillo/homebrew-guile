class GuileXmlrpc < Formula
  desc "XMLRPC module for Guile"
  homepage "https://github.com/aconchillo/guile-xmlrpc"
  url "https://download.savannah.gnu.org/releases/guile-xmlrpc/guile-xmlrpc-0.4.0.tar.gz"
  sha256 "357755571b85a1e07d1caafdc63ad1c186913ec9ad94b44631df37c8abfc91ac"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-xmlrpc-0.4.0"
    sha256 cellar: :any_skip_relocation, catalina:     "1e83148cac523bab2089b1b8e305732252dca4d42511b825391071c4f3bf2ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f212a427445e3c3f8b0211da6b3f9fe7fcfd6c4c8bf4e12d742c122b5539d6db"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
