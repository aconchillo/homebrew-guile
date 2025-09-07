class GuileGcrypt < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://notabug.org/cwebber/guile-gcrypt"
  url "https://notabug.org/cwebber/guile-gcrypt/archive/v0.5.0.tar.gz"
  sha256 "92dd5d2253ecb96a30483850528a76f6e1d7e53e5163670a7d9126f78fe4cfbe"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gcrypt-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b533ddfc0072e3d6a578ed6db6c718b01a61a670619d5b46d6886cdfbefc29fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637dda3f90bb2245b0381801c3aa5451b97883f8875ff2a1f192d5dcd8a03d8f"
    sha256 cellar: :any_skip_relocation, ventura:       "712b5641a3476c4bfb041dd2619cdeb5c44dc2764aeacc20a12f0c5a70489f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acba33c7293df5feba48d136338821a4278b40d3f365bf9a004fe3f5ad353315"
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
