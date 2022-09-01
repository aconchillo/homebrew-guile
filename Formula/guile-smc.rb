class GuileSmc < Formula
  desc "GNU Guile state machine compiler"
  homepage "https://github.com/artyom-poptsov/guile-smc"
  url "https://github.com/artyom-poptsov/guile-smc/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "94b914a38e18bbb7495c100735a7163a651c4f5cdad069d90cde29e8d5339bf8"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-smc-0.5.0"
    sha256 big_sur:      "58ecad142a71babe129cf255cfeb9db5a5a79231619f64a2c8dcbd7cd9779046"
    sha256 x86_64_linux: "f60b0fabbbfd707740b9b96dff7fdd298b78a3085ddc21abfb434bbd320d581d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-lib"

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
    smc = testpath/"smc.scm"
    smc.write <<~EOS
      (use-modules (smc fsm))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", smc
  end
end
