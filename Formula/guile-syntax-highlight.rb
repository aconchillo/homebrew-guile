class GuileSyntaxHighlight < Formula
  desc "General-purpose syntax highlighting library for GNU Guile"
  homepage "https://dthompson.us/projects/guile-syntax-highlight.html"
  url "https://files.dthompson.us/guile-syntax-highlight/guile-syntax-highlight-0.2.0.tar.gz"
  sha256 "695a8c000fa61146f53c4a18030c8a26aef0e7841e0fe43c0d1d1a4341f89660"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-syntax-highlight-0.2.0"
    sha256 cellar: :any_skip_relocation, monterey:     "c0ea1d965009215fc5020b55ec61a053d98587b9081e769e4a3bca6eaedcdc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "526fa76ef9ed0c41043159257a1a45a04dc6c935c0188fa86c4cef4b107b207e"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

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
    syntax = testpath/"syntax.scm"
    syntax.write <<~EOS
      (use-modules (syntax-highlight))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", syntax
  end
end
