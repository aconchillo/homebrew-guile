class GuileGcrypt < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://notabug.org/cwebber/guile-gcrypt"
  url "https://notabug.org/cwebber/guile-gcrypt/archive/v0.4.0.tar.gz"
  sha256 "35f0681e01defab0aaa2a83227c0be836b0a1303dd1f7279497a76dd1255b17e"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gcrypt-0.4.0_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "38a43821f491e0c052920b0f707fa48a13667c82d7d9e401e2a94bec409889fb"
    sha256 cellar: :any_skip_relocation, ventura:      "0b534ec8557ba0c7f5b21f9a1b1c1d3e92f87243e4ba77d87df205d15f805dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4869571b7e1d3d6b0250f193941cc96da3c45f64776a7f6cf3471c1212de2bdb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libgcrypt"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libgcrypt-prefix=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  def post_install
    # Touch package-config.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch "#{lib}/guile/3.0/site-ccache/gcrypt/package-config.go"
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
    gcrypt = testpath/"gcrypt.scm"
    gcrypt.write <<~EOS
      (use-modules (gcrypt base64) (rnrs bytevectors))
      (base64-encode (string->utf8 "hello"))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gcrypt
  end
end
