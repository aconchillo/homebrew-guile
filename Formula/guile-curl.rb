class GuileCurl < Formula
  desc "Guile bindings for the CURL network client library"
  homepage "https://github.com/spk121/guile-curl"
  url "https://github.com/spk121/guile-curl/archive/refs/tags/v0.9.tar.gz"
  sha256 "d241f27c2a6d2ac768ce1ae64fd27e6854b34ace6ce35ce810fb41a2a7b20ed6"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-curl-0.9_1"
    sha256 cellar: :any,                 arm64_sonoma: "16d68b94b42144f9361f3f6c3e784a171491ebc61910e346aeefc3b571777055"
    sha256 cellar: :any,                 ventura:      "3593fe5fc4c21bb6104fcf14b2d12613f65e3930322ae1dc65813a27c9470f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b1ce7d1fd9f4e2ae75a9d6b5ef45a1d0d5d42eb4a8a7f1d575a1efbc01c3d4a"
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
