class GuileRedis < Formula
  desc "Redis module for Guile"
  homepage "https://github.com/aconchillo/guile-redis"
  url "https://download.savannah.gnu.org/releases/guile-redis/guile-redis-2.0.0.tar.gz"
  sha256 "58b70a8af1c2720fbc2902b0d614c33fcbda0dc44128d23d38752d52c6fbf4c5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-redis-2.0.0"
    cellar :any_skip_relocation
    sha256 "7fa9d85f87f1f606da86abc44904a2a28f3d479af5551b4fa36d42a7ca9a389d" => :catalina
    sha256 "0a1e937cb1dd3a9f50ee459a61db69fc6e42d942f5bfaf91c3e578d70d192a03" => :x86_64_linux
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
