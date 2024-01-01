class Fibers < Formula
  desc "Concurrency library for Guile"
  homepage "https://github.com/wingo/fibers"
  url "https://github.com/wingo/fibers/releases/download/v1.3.1/fibers-1.3.1.tar.gz"
  sha256 "a5e1a9c49c0efe7ac6f355662041430d4b64e59baa538d2b8fb5ef7528d81dbf"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/fibers-1.3.1_1"
    sha256 arm64_sonoma: "196f88b9b1355c93a9a4614aba258fcc2c2890a5547881746cf2abe525b61df8"
    sha256 ventura:      "cd9c67fe2d33997bf17a0a15ab332da36bdff28443f6e3c88f45621fc1f887ed"
    sha256 x86_64_linux: "4eb749ecfda5083a14f92ef8b2233889451f9c9fe6f60a9b3a03202ae15cfc20"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libevent"

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
    fibers = testpath/"fibers.scm"
    fibers.write <<~EOS
      (use-modules (fibers))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", fibers
  end
end
