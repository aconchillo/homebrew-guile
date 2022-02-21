class GuileBytestructures < Formula
  desc "Library for structured access to bytevector contents"
  homepage "https://github.com/TaylanUB/scheme-bytestructures"
  url "https://github.com/TaylanUB/scheme-bytestructures/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2c9a990f6bb60df3c430c74f8856cbc5ea95c3e9e609bb1e07811e321c0967ce"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bytestructures-1.0.10"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "38aa91339b74ef12abaca13957350e8c5c1b7398899e8bb98ea88f7c50a67729"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5540a0119bba1a8b9bcfcdd313db76e67537fbd54c5911005a6a355a80c892fb"
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
    bytestructures = testpath/"bytestructures.scm"
    bytestructures.write <<~EOS
      (use-modules (bytestructures guile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", bytestructures
  end
end
