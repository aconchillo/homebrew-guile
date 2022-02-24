class GuileOauth < Formula
  desc "OAuth module for Guile"
  homepage "https://github.com/aconchillo/guile-oauth"
  url "https://download.savannah.gnu.org/releases/guile-oauth/guile-oauth-1.1.0.tar.gz"
  sha256 "e7e320b849d7141c1617e559f2d22fd36d493a45a7df2c1c8ac09ee9f9b6c1d3"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-oauth-1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "6c00d20813e03ef471fd6646bbfc808b2d2396974bc99ecd12bd9e738b5ab76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e5b55a683c59603a04ccdbb8b924455ce119eda69b155184ae27e7db8bcafeb"
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
