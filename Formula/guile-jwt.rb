class GuileJwt < Formula
  desc "JSON Web Token module for Guile"
  homepage "https://github.com/aconchillo/guile-jwt"
  url "https://download.savannah.gnu.org/releases/guile-jwt/guile-jwt-0.3.0.tar.gz"
  sha256 "97c5542a536c8862409fc9c603daebbd687f575e76d49b05561fcaa9b53c4a6f"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jwt-0.3.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a1e6bd1cdb247b3b272856505aee08b54cabf1d266ad7fed40019910182d3663"
    sha256 cellar: :any_skip_relocation, ventura:      "9b45857253801f715e36acd6adfe44a453c08f5706b2e9f69ac8533e0641bda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4077cefd06906f1d4c05cd81b51548905f27c8cf59be3bc3c00314311f21fa3b"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-gcrypt"
  depends_on "guile-json"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    jwt = testpath/"jwt.scm"
    jwt.write <<~EOS
      (use-modules (jwt))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", jwt
  end
end
