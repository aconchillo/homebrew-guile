class GuileZlib < Formula
  desc "GNU Guile bindings to the zlib compression library"
  homepage "https://notabug.org/guile-zlib/guile-zlib"
  url "https://notabug.org/guile-zlib/guile-zlib/archive/v0.1.0.tar.gz"
  sha256 "25c726b570a06d21bc6fd7ec6093f377c749ce2efdd1d1516ac1b595f3f94ee9"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zlib-0.1.0_2"
    sha256 cellar: :any_skip_relocation, ventura:      "07efe15c658fd6380daddcaf3a31167a62759fda73757a3df31909c0f45d25ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfa69fd8c74d1d56e925de0f2d55ea6c2cbd62fbf19497fce83dbbbd1d45e810"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "zlib"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/zlib/config.go"
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
    zlib = testpath/"zlib.scm"
    zlib.write <<~EOS
      (use-modules (zlib))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zlib
  end
end
