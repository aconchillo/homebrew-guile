class Guilescript < Formula
  desc "Guile to JavaScript compiler"
  homepage "https://github.com/aconchillo/guilescript"
  url "https://github.com/aconchillo/guilescript/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c925dea83aaca7813519a1acf3f145b5774f950f8c41c5f8f9a175f122b5f4f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guilescript-0.2.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "36a48cb51a89ac21c2eec4830ebd6a59bae4485915fe624bd9309dfb308117e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f52ca12673f0b3779034dacd919bd2e818ede41344b1edfe7d86f537b8f329c"
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
