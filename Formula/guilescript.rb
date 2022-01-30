class Guilescript < Formula
  desc "Guile to JavaScript compiler"
  homepage "https://github.com/aconchillo/guilescript"
  url "https://github.com/aconchillo/guilescript/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c925dea83aaca7813519a1acf3f145b5774f950f8c41c5f8f9a175f122b5f4f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guilescript-0.1.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "3e90b7f5edf6a492f0cfa64f60f4591c526d1cca3d836a41b2b0733d5c5fd86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e28af1a5924759806cde82b5261e399f92688e9d44454818d522a5e4930fa202"
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
