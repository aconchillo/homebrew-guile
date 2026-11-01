class GuileCommonmark < Formula
  desc "Guile library for parsing CommonMark"
  homepage "https://github.com/OrangeShark/guile-commonmark"
  url "https://github.com/OrangeShark/guile-commonmark/releases/download/v0.1.2/guile-commonmark-0.1.2.tar.gz"
  sha256 "56d518ece5e5d94c1b24943366149e9cb0f6abdb24044c049c6c0ea563d3999e"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-commonmark-0.1.2_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dd1efe34f992a8604ece55b0e19048b528ddb67ebd2b1a7de1f71cede6a7e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5e4df185c07588046efac6057db6ec7f480bf726fa224643fcd5124c19ad3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c1c0f130878afcf0b6fdd6a1f1efb8a208dd73ede5eeb21201db291ae4826d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"configure.ac", "2.2 2.0", "3.0"

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
    commonmark = testpath/"commonmark.scm"
    commonmark.write <<~EOS
      (use-modules (commonmark sxml))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", commonmark
  end
end
