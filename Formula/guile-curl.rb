class GuileCurl < Formula
  desc "Guile bindings for the CURL network client library"
  homepage "https://github.com/spk121/guile-curl"
  url "https://github.com/spk121/guile-curl/archive/v0.8.tar.gz"
  sha256 "2a541af4281783c3e60f1fefee459b34d740bba3c844c308a2d615a228676c64"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-curl-0.8"
    cellar :any
    sha256 "8f8a8efcc4ab132e14929c92644a9b8b6d684aaced9464d2d3e7de3560daa58d" => :catalina
    sha256 "84ea01a8f0d5bf780700f8bf9d8f25c5d0146d8635ee41323b5ec975bd626e28" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "curl"
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "-j1"
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
    curl = testpath/"curl.scm"
    curl.write <<~EOS
      (use-modules (curl))
      (curl-easy-init)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", curl
  end
end
