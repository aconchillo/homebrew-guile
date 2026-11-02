class GuileIni < Formula
  desc "GNU Guile library for working with INI format"
  homepage "https://github.com/artyom-poptsov/guile-ini"
  url "https://github.com/artyom-poptsov/guile-ini/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8068aededc281770b9ca456640d90a097357853a73e560e11bcd68778154ca66"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ini-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a7d97ecfb092e240bb0d7f64d9186c62bb07a0b8aca859f2671cd51aa3a423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93af046ad675b8913d43c8e33728d6284978701f58426be0edf0798f79b94d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c335d4205372664bcad5ad870e06d6aae9fd2b09c63dcf87e0e57c69893a7c4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-smc"

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
    ini = testpath/"ini.scm"
    ini.write <<~EOS
      (use-modules (ini))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ini
  end
end
