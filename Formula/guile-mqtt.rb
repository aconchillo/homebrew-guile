class GuileMqtt < Formula
  desc "Guile bindings for libmosquitto MQTT client library"
  homepage "https://github.com/mdjurfeldt/guile-mqtt"
  url "https://github.com/mdjurfeldt/guile-mqtt/releases/download/v1.0.0/guile-mqtt-1.0.0.tar.gz"
  sha256 "ebe5371477b06dd23c97baf8a550ab7740cd28fcb80471f2da6fe1710ec1c814"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-mqtt-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "011fc703c6a9561063cd071823572b23ae8635c063f832b9d9f30323a8d94d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3e0bae8603f3661fe8096da44f6a441915f1f61e9f7bafb649a01fbd19a52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "553cb79f274ffcf6b453aa156c36121e24dfa9e855ef2412e1d5234b796a9750"
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
