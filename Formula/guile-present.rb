class GuilePresent < Formula
  desc "Create SVG or PDF presentations in Guile"
  homepage "https://wingolog.org/projects/guile-present/"
  url "https://wingolog.org/pub/guile-present/guile-present-0.3.0.tar.gz"
  sha256 "d564f7c231da5ee86e8b81cbab106c84396ff1799f36d4cdee5d17500f2155e1"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-present-0.3.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b15ca9f13a6d30cc9c9f0525f9258a6357903931e0342577802b9627f64bf510"
    sha256 cellar: :any_skip_relocation, ventura:      "1ae5c7da2146e9cf543138a16f032b163654ca6a3df65a326cf06c4c8a046d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "000d80202c1850cbee98f363d15f0326b1139247016abc2916e21e7fb6946895"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-cairo"
  depends_on "guile-lib"
  depends_on "guile-rsvg"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    inreplace buildpath/"configure.ac", "2.2 2.0", "3.0"
    inreplace buildpath/"Makefile.am", "ccache", "site-ccache"

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
    present = testpath/"present.scm"
    present.write <<~EOS
      (use-modules (present) (present org-mode) (present svg))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", present
  end
end
