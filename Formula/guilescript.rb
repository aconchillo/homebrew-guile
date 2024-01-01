class Guilescript < Formula
  desc "Guile to JavaScript compiler"
  homepage "https://github.com/aconchillo/guilescript"
  url "https://github.com/aconchillo/guilescript/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c925dea83aaca7813519a1acf3f145b5774f950f8c41c5f8f9a175f122b5f4f"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guilescript-0.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "04c4beae7412af623989cc2eb9d0081b87fc479fe88d5642b446c75939b6fd0d"
    sha256 cellar: :any_skip_relocation, ventura:      "9b8b780cd3e98a24c11f7a83f1c097aca538de5e77febcb56a116ea2b61183a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a84160d72d2b1332e3a9c754c86a8aaee01682aab7905923718faae75df09c6"
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
    guilescript = testpath/"guilescript.scm"
    guilescript.write <<~EOS
      (use-modules (language guilescript compile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", guilescript
  end
end
