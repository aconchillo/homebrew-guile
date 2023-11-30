class GuileDsv < Formula
  desc "Guile module for delimiter-separated values (DSV) data format"
  homepage "https://github.com/artyom-poptsov/guile-dsv"
  url "https://github.com/artyom-poptsov/guile-dsv/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "87b6973696871eae40def021c98f43e3011ebc7ed9cfa6e730405c9ec66fb7c7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dsv-0.7.0"
    sha256 monterey:     "57263e6549cb5ca177868ceb559875a1dc37471eafa31bdf3f79a4176a69d72f"
    sha256 x86_64_linux: "4adb390500de705d0ac319f079b68efa736d350320da2444600853c70bb4abb8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "help2man"

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
    dsv = testpath/"dsv.scm"
    dsv.write <<~EOS
      (use-modules (dsv))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dsv
  end
end
