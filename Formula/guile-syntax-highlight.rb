class GuileSyntaxHighlight < Formula
  desc "General-purpose syntax highlighting library for GNU Guile"
  homepage "https://dthompson.us/projects/guile-syntax-highlight.html"
  url "https://files.dthompson.us/releases/guile-syntax-highlight/guile-syntax-highlight-0.2.0.tar.gz"
  sha256 "695a8c000fa61146f53c4a18030c8a26aef0e7841e0fe43c0d1d1a4341f89660"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-syntax-highlight-0.2.0_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb0eedbea218e6395f5bb03c03d60186e2bfbbe779e47f95dc86612d812f5ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aebcb3d8a6fe6b96d379202b284e4b13ede7de37ad02da7a41828d287f841f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9cd71175a150286983fa3b6d144f1f4003947f29b38c98b209c11ba3161a6d"
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
