class GuileOauth < Formula
  desc "OAuth module for Guile"
  homepage "https://github.com/aconchillo/guile-oauth"
  url "https://download.savannah.gnu.org/releases/guile-oauth/guile-oauth-1.3.0.tar.gz"
  sha256 "33ed60eb471df34e37a26f228016b3db6b3e65f69d66bf226051dbbefcc29b15"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-oauth-1.3.0_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b6344392d6a39b286a261c22906b0dbb9b56cfaf73b933b6f3ea26684d52b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f72271ff6ac9d924b26c048de65e77d0f49603bf1fd36980697e68aa0e65ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0093b3dccfd9fd5429eac6dc7a3e7d494996c9b841a0bdba58ef59d23c6f627"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-gcrypt"
  depends_on "guile-gnutls"
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
