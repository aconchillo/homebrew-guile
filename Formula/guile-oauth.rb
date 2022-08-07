class GuileOauth < Formula
  desc "OAuth module for Guile"
  homepage "https://github.com/aconchillo/guile-oauth"
  url "https://download.savannah.gnu.org/releases/guile-oauth/guile-oauth-1.3.0.tar.gz"
  sha256 "33ed60eb471df34e37a26f228016b3db6b3e65f69d66bf226051dbbefcc29b15"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-oauth-1.1.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "866f5c2370b013c09d169b92d93483dee5489994ca70a158c791303cd1a553b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "db4958dd25f6a5a719cb76d9571a44d37d8127d727754b94357340c5324e3f3b"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
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
    oauth = testpath/"oauth.scm"
    oauth.write <<~EOS
      (use-modules (oauth oauth1) (oauth oauth2))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", oauth
  end
end
