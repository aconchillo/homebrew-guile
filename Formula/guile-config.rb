class GuileConfig < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://gitlab.com/a-sassmannshausen/guile-config/"
  url "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.5.1/guile-config-0.5.1.tar.gz"
  sha256 "c30bb76bf27dcdbda7cc13733cf907e3b28d14dec2a55a89097514be61f3278e"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-config-0.5.1_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a823ac42c02d3ebca6b1d1907f026b2b93c8599fffc1c0f731fa7851ca8a04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a6e0f23e8b23850f647a4a2d6d1aebfd5db7890f5e4e17c2f6bb500e6a9166f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8333107c3fa469e6ebae81a9f8c25054bea8f1e428a15e308eeb5a17a26e18a"
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
