class GuileJwt < Formula
  desc "JSON Web Token module for Guile"
  homepage "https://github.com/aconchillo/guile-jwt"
  url "https://download.savannah.gnu.org/releases/guile-jwt/guile-jwt-0.3.0.tar.gz"
  sha256 "97c5542a536c8862409fc9c603daebbd687f575e76d49b05561fcaa9b53c4a6f"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jwt-0.3.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db35c83a9021af4b98c7c794bd9971dc78285da20ceec94d34f6f6eb8ac1806a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7a75ee535f1fde322149b1b67649246b6cb9f39a60d3686616af9e8289b26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c555efa92be70ee9cf0e560e10237fc80f88760f7f6a8a9a4e5f1b3e7e6eb1"
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
