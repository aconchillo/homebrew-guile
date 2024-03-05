class GuileGit < Formula
  desc "GNU Guile library providing bindings to libgit2"
  homepage "https://gitlab.com/guile-git/guile-git"
  url "https://gitlab.com/guile-git/guile-git/-/archive/v0.6.0/guile-git-v0.6.0.tar.gz"
  sha256 "aea0820529711450a46e36909ccd999c83bff563dbf4875bbb422fd60874bd7f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-git-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3bfb4d4a8f449476840f1e37901f4985727bba5787d6e7fba199774de67d91a5"
    sha256 cellar: :any_skip_relocation, ventura:      "106d9342ba1115aea3c8c67134907890f86535da641ca009ea94e1bdf3434d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "066fdb751074d8de2b0f5c95ad67025910f8d770241cecd66a46b6d703839c93"
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
