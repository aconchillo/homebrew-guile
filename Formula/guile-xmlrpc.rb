class GuileXmlrpc < Formula
  desc "XMLRPC module for Guile"
  homepage "https://github.com/aconchillo/guile-xmlrpc"
  url "https://download.savannah.gnu.org/releases/guile-xmlrpc/guile-xmlrpc-0.4.0.tar.gz"
  sha256 "357755571b85a1e07d1caafdc63ad1c186913ec9ad94b44631df37c8abfc91ac"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-xmlrpc-0.4.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "422ae7d822047607f47e00067564328ccd0eb4a202bbdafcaf654b83b70549d5"
    sha256 cellar: :any_skip_relocation, ventura:      "9aa6f02b3f39eb77005db64eb60b2411b6ffa40728cfc7789da6c5b35d55d1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e39a1f96c47cf1de763c943c8552d0441cdbf6755078532705384719953582ea"
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
