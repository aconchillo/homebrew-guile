class GuileRedis < Formula
  desc "Redis module for Guile"
  homepage "https://github.com/aconchillo/guile-redis"
  url "https://download.savannah.gnu.org/releases/guile-redis/guile-redis-2.2.0.tar.gz"
  sha256 "3dcdc585e72d490c9ec91106ecab6a3b850ea0a672d9d8d99b584d945bf59370"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-redis-2.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2304325b00f15fa79e9fbc36c554d844cab0f49f29a74a613841190d0fee1edd"
    sha256 cellar: :any_skip_relocation, ventura:      "13fbf6b51e2d0d2e999b629e86a27a682b8d9e3b52e9564947e3775400542554"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b743a8cc501481a12d165a057429f103221d28d906afc53564ccd041a975f4c4"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
