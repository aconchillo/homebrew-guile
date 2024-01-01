class GuileRsvg < Formula
  desc "RSVG library for Guile"
  homepage "https://wingolog.org/projects/guile-rsvg/"
  url "https://wingolog.org/pub/guile-rsvg/guile-rsvg-2.18.1.tar.gz"
  sha256 "07ca914542f3621bb9b2d72888592c3ad7c292aae1ce79cdcfd90f1ecd10ce8c"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-rsvg-2.18.1_1"
    sha256 cellar: :any,                 big_sur:      "561e9cec0e6e06d37810e8f4172ba31aadf34940be51424c229657824d4a77ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c435e4bcca3bf54e41ee78ca69e7366829f3f19435d1d51a09ddc3500c944ab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-cairo"
  depends_on "librsvg"

  patch :DATA

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
    rsvg = testpath/"rsvg.scm"
    rsvg.write <<~EOS
      (use-modules (rsvg))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", rsvg
  end
end

__END__
--- a/configure.ac	2022-02-18 21:48:43.000000000 -0800
+++ b/configure.ac	2022-02-18 21:36:39.000000000 -0800
@@ -37,7 +37,7 @@
         [WARN_CFLAGS="-Wall -Werror"], [])
 AC_SUBST(WARN_CFLAGS)

-GUILE_PKG([2.2 2.0 1.8])
+GUILE_PKG([3.0 2.2 2.0 1.8])

 PKG_CHECK_MODULES(GUILE_CAIRO, guile-cairo >= 1.4.0)
 AC_SUBST(GUILE_CAIRO_LIBS)

--- a/Makefile.am	2022-02-18 21:49:45.000000000 -0800
+++ b/Makefile.am	2022-02-18 21:50:49.000000000 -0800
@@ -25,7 +25,7 @@
 BUILT_SOURCES = env
 CLEANFILES = env

-scmdir=$(prefix)/share/guile/site
+scmdir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)

 scm_DATA = rsvg.scm

--- a/rsvg/Makefile.am	2022-02-18 21:56:27.000000000 -0800
+++ b/rsvg/Makefile.am	2022-02-18 22:00:41.000000000 -0800
@@ -3,7 +3,7 @@
 lib_builddir = $(shell cd $(top_builddir)/guile-rsvg && pwd)
 docs_builddir = $(shell cd $(top_builddir)/doc && pwd)

-moduledir=$(prefix)/share/guile/site/rsvg
+moduledir=$(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)/rsvg

 module_DATA =
