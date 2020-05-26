class GuileGcrypt < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://notabug.org/cwebber/guile-gcrypt"
  url "https://notabug.org/cwebber/guile-gcrypt/archive/v0.3.0.tar.gz"
  sha256 "07394c3de4f31a36ca2b670e1998c526de891d9436f12e94d8862ab081274d6a"

  bottle :unneeded

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

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
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

    system "guile", gcrypt
  end
end
