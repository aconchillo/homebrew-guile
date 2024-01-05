class GuileBytestructures < Formula
  desc "Library for structured access to bytevector contents"
  homepage "https://github.com/TaylanUB/scheme-bytestructures"
  url "https://github.com/TaylanUB/scheme-bytestructures/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "fd5787a4bfa463a1efb736adf969b291abc0333c1d477e0de61c58e528c33950"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bytestructures-2.0.1"
    sha256 cellar: :any_skip_relocation, big_sur:      "97153acc9836c45d7192b4c5d2fe8e567de11af4b1db84f9cd2280ec77b17021"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cdc1a63a99a1ffc7d392715354f2798017f4ea13fc13b17861628a6e846490fb"
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
