class GuileDbi < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/refs/tags/guile-dbi-3.2.0.tar.gz"
  sha256 "3e7729cf389878d069f7c5884dba95be0dc4a0e32116d830bdebdaf9ebbd7291"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbi-3.2.0"
    sha256 cellar: :any, arm64_tahoe:   "e7c90df300ad8f44cba4b72ad0722eea7461b7999d44dafd7fb5a2a3914db52b"
    sha256 cellar: :any, arm64_sequoia: "9a01c04391aff4690922040ec5bd598857d0ce007b4be3481c404a6a30136035"
    sha256 cellar: :any, x86_64_linux:  "cc0398947ce368c0953eb83f52afe08f03ac8dccc391959561691863f3608989"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libtool"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chdir "guile-dbi" do
      # automake's default GNU strictness requires a NEWS file.
      touch "NEWS"
      system "autoreconf", "-vif"
      system "./configure", "--prefix=#{prefix}"
      # GUILE_SITE defaults to guile's own site dir, outside our prefix.
      system "make", "install", "GUILE_SITE=#{share}/guile/site/3.0"
    end
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
    dbi = testpath/"dbi.scm"
    dbi.write <<~EOS
      (use-modules (dbi dbi))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dbi
  end
end
