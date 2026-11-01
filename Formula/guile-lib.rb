class GuileLib < Formula
  desc "Accumulation place for pure-scheme Guile modules"
  homepage "https://www.nongnu.org/guile-lib/"
  url "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-0.2.8.1.tar.gz"
  sha256 "1374c2d839e6a33d190cd1dabd9c7f87753f8384f55b866f3e142155c22b49b1"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-lib-0.2.8.1_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dddb6db40dbcce01064501814ba5575af3412b2974e1d5b543302fabe6e3159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc920aef042b61167e052b91a75e5c31b9bf8b7d64934b0611901b3378fc3817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbe427e7ec49abf77c86ad8d6a872f7c5fc8a25121b8cb9d8cf355f8176e6b2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"
    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

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
    lib = testpath/"lib.scm"
    lib.write <<~EOS
      (use-modules (apicheck))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", lib
  end
end

__END__
--- a/configure.ac	2022-12-16 15:15:11
+++ b/configure.ac	2022-12-16 15:15:32
@@ -92,8 +92,8 @@
    SITEDIR="$GUILE_GLOBAL_SITE";
    SITECCACHEDIR="$GUILE_SITE_CCACHE";
 else
-   SITEDIR="$datadir/guile-lib";
-   SITECCACHEDIR="$libdir/guile-lib/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
+   SITEDIR="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION";
+   SITECCACHEDIR="$libdir/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
 fi
 AC_SUBST([SITEDIR])
 AC_SUBST([SITECCACHEDIR])
