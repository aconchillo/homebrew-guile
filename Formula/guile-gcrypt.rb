class GuileGcrypt < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://notabug.org/cwebber/guile-gcrypt"
  url "https://notabug.org/cwebber/guile-gcrypt/archive/v0.4.0.tar.gz"
  sha256 "35f0681e01defab0aaa2a83227c0be836b0a1303dd1f7279497a76dd1255b17e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gcrypt-0.4.0"
    sha256 cellar: :any_skip_relocation, monterey:     "847b3638a22afb1e74a3e00d3cc708dd8fd5f8dab65aa0c5e682867f972e9afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fdd3f26a2ddb077abd8041c9dd8c8212df39dddb59bc7393e384b3017d012377"
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
