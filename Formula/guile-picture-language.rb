class GuilePictureLanguage < Formula
  desc "Picture Language for Guile"
  homepage "https://elephly.net/guile-picture-language/"
  url "https://git.elephly.net/software/guile-picture-language.git", revision: "a1322bf11945465241ca5b742a70893f24156d12"
  version "0.0.1"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-picture-language-0.0.1_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2c3d03c86d82c80d8f7d50b22edee67899524ab3822a9c36b78e0faf976dd6b7"
    sha256 cellar: :any_skip_relocation, ventura:      "59e5745fbe546b91e19601a7d790fc0cc8e155ea7e945d4a30a16b1604c30bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cf8d4e1a01713fe62d38650bc0ded90f079755a44730497fcaad007a6967b6bb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-cairo"
  depends_on "guile-rsvg"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./bootstrap.sh"
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
    pict = testpath/"pict.scm"
    pict.write <<~EOS
      (use-modules (pict))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", pict
  end
end
