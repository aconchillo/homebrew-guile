class GuileConfig < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://gitlab.com/a-sassmannshausen/guile-config/"
  url "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.4.0/guile-config-0.4.0.tar.gz"
  sha256 "c0f22fb2739e05da734943d0a1e0e06f587f18ad0dd88bb695433bdd4c759b5c"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
    EOS
  end

  test do
    config = testpath/"config.scm"
    config.write <<~EOS
      (use-modules (config))
    EOS

    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "guile", config
  end
end
