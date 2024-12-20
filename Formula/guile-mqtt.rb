class GuileMqtt < Formula
  desc "Guile bindings for libmosquitto MQTT client library"
  homepage "https://github.com/mdjurfeldt/guile-mqtt"
  url "https://github.com/mdjurfeldt/guile-mqtt/releases/download/v0.2.1/guile-mqtt-0.2.1.tar.gz"
  sha256 "faa7eb530f32218f2239b1152db83a6ce7e240d4792e4c369fda0732bdc94399"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-mqtt-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "41f3f2204aeb4340ee6dc5a1b73e1e73a391afeaac1e4f5e98b994e7c96588d4"
    sha256 cellar: :any_skip_relocation, ventura:      "3c14629d1d45f632891d84b90a92a2241b5d148cd45e1197386d1c8fb27df745"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8fa7b97c5a12e400984d796745535fb8434fa20d138617a95263aff688cf2b0e"
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
