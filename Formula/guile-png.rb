class GuilePng < Formula
  desc "Portable Network Graphics library for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-png"
  url "https://github.com/artyom-poptsov/guile-png/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7f68028e37931a60a37286e3ba0dba221dea521d71975a5cb6d2f51a53e188ba"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-png-0.7.2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4f66dd7a6c4cc8372b1085c75aae15754b80e7d77ee414a10988395775e55d9d"
    sha256 cellar: :any_skip_relocation, ventura:      "405213e54643696950c6780f5e56f4ecff1486ff61a6efeb9dac31cdfb95d2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c2f6f6d90e7f0ac1ed0fd2d36c885c2995cecb34a1182b4d11e89b0e8ec57d3"
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
