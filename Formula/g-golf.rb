class GGolf < Formula
  desc "Guile Object Library for GNOME"
  homepage "https://www.gnu.org/software/g-golf/"
  url "https://ftp.gnu.org/gnu/g-golf/g-golf-0.8.0-rc-3.tar.gz"
  version "0.8.0-rc-3"
  sha256 "d73e5512de304f62e727b328ac65f592f608d60a5942a08d350f3c6b2146ce82"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/g-golf-0.8.0-rc-3"
    sha256 cellar: :any,                 arm64_sonoma: "fc73a3cc7235941a96cd0c712d1eab9b6c17e037a672e36cfa361145309dda5f"
    sha256 cellar: :any,                 ventura:      "0ffce948e7f0fb37184959a9656b694bcb58aad464d90db1f36b7b91f929f4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "280f6e11ced9be63ade7fd8b36fd6ca0f121357b6e53b7e1561ea38287e4adeb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "guile"
  depends_on "guile-lib"

  uses_from_macos "libffi", since: :catalina

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    inreplace buildpath/"g-golf/init.scm", "libglib-2.0", "#{HOMEBREW_PREFIX}/lib/libglib-2.0"
    inreplace buildpath/"g-golf/init.scm", "libgobject-2.0", "#{HOMEBREW_PREFIX}/lib/libgobject-2.0"
    inreplace buildpath/"g-golf/init.scm", "libgirepository-1.0", "#{HOMEBREW_PREFIX}/lib/libgirepository-1.0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "-j1", "install"
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
    ggolf = testpath/"ggolf.scm"
    ggolf.write <<~EOS
      (use-modules (g-golf))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ggolf
  end
end

__END__
--- a/configure.ac	2022-12-15 11:09:06
+++ b/configure.ac	2022-12-16 15:11:17
@@ -80,8 +80,8 @@
    SITEDIR="$GUILE_GLOBAL_SITE";
    SITECCACHEDIR="$GUILE_SITE_CCACHE";
 else
-   SITEDIR="$datadir/g-golf";
-   SITECCACHEDIR="$libdir/g-golf/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
+   SITEDIR="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION";
+   SITECCACHEDIR="$libdir/guile/$GUILE_EFFECTIVE_VERSION/site-ccache";
 fi
 AC_SUBST([SITEDIR])
 AC_SUBST([SITECCACHEDIR])
--- a/libg-golf/Makefile.am	2022-12-15 11:19:14
+++ b/libg-golf/Makefile.am	2022-12-15 11:19:22
@@ -23,7 +23,9 @@

 #include $(top_srcdir)/am/guile.mk

-lib_LTLIBRARIES = \
+extlibdir = $(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions
+
+extlib_LTLIBRARIES = \
 	libg-golf.la

 libg_golf_la_sources = \
