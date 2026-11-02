class Fibers < Formula
  desc "Concurrency library for Guile"
  homepage "https://codeberg.org/guile/fibers"
  url "https://codeberg.org/guile/fibers/archive/v2.0.0.tar.gz"
  sha256 "5cf63d8afbafe94b51fc94ccaf24f1643438dabfdd8f5fa83ff89cb0b2650b13"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/fibers-2.0.0"
    sha256 arm64_tahoe:   "d6fc1d901de79765aa723e56391f04364f3905e9cddebc7dfb113e73d1c5c947"
    sha256 arm64_sequoia: "ba395e6c212f1039d1f653bb05cebbfe028c3a592775b6d7a623f764be69114c"
    sha256 x86_64_linux:  "058378c6d91bae131fb354895fee3af08a264eceb9ed56a2ade4a001d843351b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libevent"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"
    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

    system "./autogen.sh"
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
    fibers = testpath/"fibers.scm"
    fibers.write <<~EOS
      (use-modules (fibers))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", fibers
  end
end
