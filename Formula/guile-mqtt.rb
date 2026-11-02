class GuileMqtt < Formula
  desc "Guile bindings for libmosquitto MQTT client library"
  homepage "https://github.com/mdjurfeldt/guile-mqtt"
  url "https://github.com/mdjurfeldt/guile-mqtt/releases/download/v1.0.0/guile-mqtt-1.0.0.tar.gz"
  sha256 "ebe5371477b06dd23c97baf8a550ab7740cd28fcb80471f2da6fe1710ec1c814"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-mqtt-0.2.1_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2d2833c438c271be4d13dd1ad6ac35ea859453b8d6256155c80dcf47d3d643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8502fb6961889819bf50717f9068df42e8002904f872920eb21821437afa73d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd56a53a2d1f14cd80f1e94237eaf198d86f78a6f7e52e45bdd0456294e2f4d"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "mosquitto"

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
    mqtt = testpath/"mqtt.scm"
    mqtt.write <<~EOS
      (use-modules (mosquitto client))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", mqtt
  end
end
