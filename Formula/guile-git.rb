class GuileGit < Formula
  desc "GNU Guile library providing bindings to libgit2"
  homepage "https://gitlab.com/guile-git/guile-git"
  url "https://gitlab.com/guile-git/guile-git/uploads/2600bb0dfdfb00bfbe46811dccad51d8/guile-git-0.4.0.tar.gz"
  sha256 "2ccee3e0520b5db354a1b7070f95e3bbaf0bb0f61c11ca92793728257a7abecf"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-git-0.4.0"
    cellar :any_skip_relocation
    sha256 "85bae69b9eea8b1bd7decbec47082a96bceffdc9433accaab0065eb6d5fdc34e" => :catalina
    sha256 "c4d341745ca0ab5cc35227878783119e574d76a60b36104e498c34f65e3c706a" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-bytestructures"
  depends_on "libgit2"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    git = testpath/"git.scm"
    git.write <<~EOS
      (use-modules (git))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", git
  end
end
