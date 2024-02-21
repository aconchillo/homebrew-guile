class GuileIni < Formula
  desc "GNU Guile library for working with INI format"
  homepage "https://github.com/artyom-poptsov/guile-ini"
  url "https://github.com/artyom-poptsov/guile-ini/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "68f7774ad214564caff1955c17ff506f897b3f555e89b942a31e6f64f3c85d87"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ini-0.5.4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0caa44527538f6a57740f10f4aa21d409e82dfa46dc3ea4f6b6ecd31db44a405"
    sha256 cellar: :any_skip_relocation, ventura:      "85bd55726b117c6cf49d15b82e459cdb5a704ead8593460cc3ac2e1367804234"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24fa8612e2cc7323fa2438756f7a5cecc58e98d2eac2c85ad6107e288d83700f"
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
