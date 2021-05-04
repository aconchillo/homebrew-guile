class GuileIni < Formula
  desc "GNU Guile library for working with INI format"
  homepage "https://github.com/artyom-poptsov/guile-ini"
  url "https://github.com/artyom-poptsov/guile-ini/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "fd78c93b143f8a1c8f96b97c47ab43a781277327e7af274b777ac5fdc1c7dce8"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-smc"

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
    ini = testpath/"ini.scm"
    ini.write <<~EOS
      (use-modules (ini))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ini
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index faf70ee..e53b6dd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -47,9 +47,10 @@ GUILE_PKG([3.0 2.2])
 GUILE_PROGS
 GUILE_SITE_DIR

-pkgdatadir="$datadir/$PACKAGE"
+GUILE_MODULE_REQUIRED([smc fsm])
+
 if test "x$guilesitedir" = "x"; then
-   guilesitedir="$pkgdatadir"
+   guilesitedir="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION"
 fi
 AC_SUBST([guilesitedir])

diff --git a/modules/ini/Makefile.am b/modules/ini/Makefile.am
index 792ea6b..3815961 100644
--- a/modules/ini/Makefile.am
+++ b/modules/ini/Makefile.am
@@ -32,7 +32,7 @@ GOBJECTS = $(SOURCES:%.scm=%.go)
 moddir=$(guilesitedir)/ini/
 nobase_dist_mod_DATA = $(SOURCES) fsm.puml

-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/ini
 nobase_nodist_ccache_DATA = $(GOBJECTS)

 # Make sure source files are installed first, so that the mtime of
