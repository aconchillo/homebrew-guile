class GuileConfig < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://gitlab.com/a-sassmannshausen/guile-config/"
  url "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.5.1/guile-config-0.5.1.tar.gz"
  sha256 "c30bb76bf27dcdbda7cc13733cf907e3b28d14dec2a55a89097514be61f3278e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-config-0.5.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "d1edf3177fd0c2dcf70c75e3a4acc6f73534556b804504f001ac6473f124b1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0ebdcabf2cc0407071704d26521abdd94425f89805c4a80d7c88eec5abe1a258"
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
