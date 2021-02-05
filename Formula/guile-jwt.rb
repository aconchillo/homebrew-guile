class GuileJwt < Formula
  desc "JSON Web Token module for Guile"
  homepage "https://github.com/aconchillo/guile-jwt"
  url "https://download.savannah.gnu.org/releases/guile-jwt/guile-jwt-0.2.0.tar.gz"
  sha256 "c26ac2336bfb8ada5dd5e253ebdafa9f0a72bc4c34bdb79e917a0ec06098641a"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jwt-0.2.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina: "ddd24d96ddafb30293034c3efcec9940202ba8823e8ae3a8db079fd21cd586a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-json"

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
