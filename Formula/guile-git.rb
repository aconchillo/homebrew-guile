class GuileGit < Formula
  desc "GNU Guile library providing bindings to libgit2"
  homepage "https://gitlab.com/guile-git/guile-git"
  url "https://gitlab.com/guile-git/guile-git/uploads/4ffd7377b0b74da4051356121b46116f/guile-git-0.5.1.tar.gz"
  sha256 "65e03731d56683f447b4c7fd0bfbf3467adad11218d5f9789d1ab859bf8e368c"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-git-0.5.1"
    sha256 cellar: :any_skip_relocation, catalina:     "292e54840e034b066a4d74eb80d3004b766d67064148779703d689287744fa10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63c156acbc1696d218c004528aab88f167cd069d1b54a253b543b3fb8e327bad"
  end

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
