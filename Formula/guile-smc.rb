class GuileSmc < Formula
  desc "GNU Guile state machine compiler"
  homepage "https://github.com/artyom-poptsov/guile-smc"
  url "https://github.com/artyom-poptsov/guile-smc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "60383bd441bc3636bd4dac6035464b1177eabc9f4229e2c447334a2e8c35f626"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  patch :DATA

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

__END__
diff --git a/configure.ac b/configure.ac
index 5e229ee..ba2a675 100644
--- a/configure.ac
+++ b/configure.ac
@@ -47,9 +47,8 @@ GUILE_PKG([3.0 2.2])
 GUILE_PROGS
 GUILE_SITE_DIR

-pkgdatadir="$datadir/$PACKAGE"
 if test "x$guilesitedir" = "x"; then
-   guilesitedir="$pkgdatadir"
+   guilesitedir="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION"
 fi
 AC_SUBST([guilesitedir])

diff --git a/modules/smc/Makefile.am b/modules/smc/Makefile.am
index 7270822..0a96147 100644
--- a/modules/smc/Makefile.am
+++ b/modules/smc/Makefile.am
@@ -31,7 +31,7 @@ GOBJECTS = $(SOURCES:%.scm=%.go)
 moddir=$(guilesitedir)/smc/
 nobase_dist_mod_DATA = $(SOURCES)

-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/smc
 nobase_nodist_ccache_DATA = $(GOBJECTS)

 # Make sure source files are installed first, so that the mtime of
