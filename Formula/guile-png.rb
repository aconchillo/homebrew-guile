class GuilePng < Formula
  desc "Portable Network Graphics library for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-png"
  url "https://github.com/artyom-poptsov/guile-png/archive/v0.5.0.tar.gz"
  sha256 "f77c998be959fc89c703b99941410beceb7f0a6ded57123ab899beca5658cecd"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-png-0.5.0"
    sha256 cellar: :any_skip_relocation, monterey:     "c9b6edd48d0ec7f434ce21f5ac35cbb67d820c3b1531dd436c3a08092bfb8229"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "301ee11554afebd9c2603cbb0b03119ebaa7142722d8b26a2823162d72c09642"
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
