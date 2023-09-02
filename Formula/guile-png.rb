class GuilePng < Formula
  desc "Portable Network Graphics library for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-png"
  url "https://github.com/artyom-poptsov/guile-png/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "18ed61c9af094c41cd6bb164d8370522b3d422d926e0c45c1abc5c6903e885a6"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-png-0.7.0"
    sha256 cellar: :any_skip_relocation, monterey:     "e42eea6f1391f9e33c50a977bd679050a07a5cac0926e523fb90e1a6095e0e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "961a54d6d55695ac76808b9baf2344832ed92432c974f9f635c140e5fe38cb79"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "guile-zlib"

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
    png = testpath/"png.scm"
    png.write <<~EOS
      (use-modules (png) (png image))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", png
  end
end
