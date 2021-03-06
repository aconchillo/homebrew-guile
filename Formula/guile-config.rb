class GuileConfig < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://gitlab.com/a-sassmannshausen/guile-config/"
  url "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.4.2/guile-config-0.4.2.tar.gz"
  sha256 "1daf04b52cfc587e73deb5722b46c12afece015caf3712c44ab7d9630a8f3b4a"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-config-0.4.2"
    sha256 cellar: :any_skip_relocation, catalina:     "811b981441e43379b49140a79f320b128fa54d2a8ccf3d34b9d4a783ebc48add"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "61d60924def8141867a324562e69be95a182f29416d14d33afe6a64ac86715c4"
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
