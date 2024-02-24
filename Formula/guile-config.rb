class GuileConfig < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://gitlab.com/a-sassmannshausen/guile-config/"
  url "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.5.1/guile-config-0.5.1.tar.gz"
  sha256 "c30bb76bf27dcdbda7cc13733cf907e3b28d14dec2a55a89097514be61f3278e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-config-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "bd2b1fff3738c1ff2e3b1d59a57b1c10574eab7f876334340cfe4ab4fcf01901"
    sha256 cellar: :any_skip_relocation, ventura:      "4e018b864c4f1aa1c26312ef92a02ea5462062fa5b728a4ba53cc7b720faf4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a26288f5b0806a4f4f522e3bf1cc1bf46d2ae028f18f27c7b40606ff70a29d6c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    config = testpath/"config.scm"
    config.write <<~EOS
      (use-modules (config))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", config
  end
end
