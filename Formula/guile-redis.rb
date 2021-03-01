class GuileRedis < Formula
  desc "Redis module for Guile"
  homepage "https://github.com/aconchillo/guile-redis"
  url "https://download.savannah.gnu.org/releases/guile-redis/guile-redis-2.1.0.tar.gz"
  sha256 "f8a4327de9170cbd87e007913eb8776fac04b194c95d97b2f7a3d05c61d16e66"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-redis-2.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina: "8b5454991a560c4dcbb7349f75d823411f20b7e2cdee1419f569d5398363fba3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    redis = testpath/"redis.scm"
    redis.write <<~EOS
      (use-modules (redis main))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", redis
  end
end
