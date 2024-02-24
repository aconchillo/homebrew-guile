class GuileJwt < Formula
  desc "JSON Web Token module for Guile"
  homepage "https://github.com/aconchillo/guile-jwt"
  url "https://download.savannah.gnu.org/releases/guile-jwt/guile-jwt-0.3.0.tar.gz"
  sha256 "97c5542a536c8862409fc9c603daebbd687f575e76d49b05561fcaa9b53c4a6f"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jwt-0.3.0"
    sha256 cellar: :any_skip_relocation, monterey:     "f95a38a887ec9915b808d18b1754a27accbab09b70c093697e47bb9d64931317"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05ead96860dd3f641dd098a91ccfacd82b40ce8dfd1e254f6c43b7cde0ab3b92"
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
