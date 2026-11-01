class GuileXmlrpc < Formula
  desc "XMLRPC module for Guile"
  homepage "https://github.com/aconchillo/guile-xmlrpc"
  url "https://download.savannah.gnu.org/releases/guile-xmlrpc/guile-xmlrpc-0.4.0.tar.gz"
  sha256 "357755571b85a1e07d1caafdc63ad1c186913ec9ad94b44631df37c8abfc91ac"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-xmlrpc-0.4.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e73eb5bbb0185676dd7efb848ec3e4d75af7cda3ec75818f7f26d76ccafb935e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0c6b234bab036bf0a4f6936ef3d0a4a2b7fc46bae7f5128af618d5716235ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817cd55baf7c14e99b61bbd8015597d372cda2c189cefa98fc639a447c2f1c11"
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
