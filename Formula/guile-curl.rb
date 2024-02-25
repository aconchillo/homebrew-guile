class GuileCurl < Formula
  desc "Guile bindings for the CURL network client library"
  homepage "https://github.com/spk121/guile-curl"
  url "https://github.com/spk121/guile-curl/archive/refs/tags/v0.9.tar.gz"
  sha256 "d241f27c2a6d2ac768ce1ae64fd27e6854b34ace6ce35ce810fb41a2a7b20ed6"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-curl-0.9"
    sha256 cellar: :any,                 catalina:     "0931b9247176554ee8ba10253e7a7d53fab35bb861e4ab0513f41e80d4e5c83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9b57b73588e976ed06bc60ce99bf7ffab7554f7a2c8f8e55721b0cff824529a9"
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
