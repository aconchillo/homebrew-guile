class GuileOauth < Formula
  desc "OAuth module for Guile"
  homepage "https://github.com/aconchillo/guile-oauth"
  url "https://download.savannah.gnu.org/releases/guile-oauth/guile-oauth-0.5.0.tar.gz"
  sha256 "03db9bbe7248e147dde31b54adb4ddbd314f8ebe370e5dfd0ab7790397dc0a27"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-oauth-0.5.0"
    cellar :any_skip_relocation
    sha256 "3e6ef18b04c9a03b317aa598a466198782140007f480bc3b31c80e6484a267ba" => :catalina
    sha256 "c0262d30eb5f4b7d96658fb8131928d0d8ee4849ffa76c4cbf2c5691d4b88f39" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "guile"
  depends_on "guile-gcrypt"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "autoreconf", "-vif"
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
      (use-modules (oauth oauth1))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", oauth
  end
end
