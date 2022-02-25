class GuileRedis < Formula
  desc "Redis module for Guile"
  homepage "https://github.com/aconchillo/guile-redis"
  url "https://download.savannah.gnu.org/releases/guile-redis/guile-redis-2.2.0.tar.gz"
  sha256 "3dcdc585e72d490c9ec91106ecab6a3b850ea0a672d9d8d99b584d945bf59370"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-redis-2.2.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "079016273078cd60f6a2090ac12e4f73f47294ededc48b987b315704395a6aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e35c2726ec6ddd344e4d0035ace4c9e190e92fb0020f3374db58eafd76ef915"
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
