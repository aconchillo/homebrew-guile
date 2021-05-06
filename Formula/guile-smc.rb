class GuileSmc < Formula
  desc "GNU Guile state machine compiler"
  homepage "https://github.com/artyom-poptsov/guile-smc"
  url "https://github.com/artyom-poptsov/guile-smc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "60383bd441bc3636bd4dac6035464b1177eabc9f4229e2c447334a2e8c35f626"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-smc-0.1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "5893c7f3ea21e15a085dae9281e0c8efdf52202c7c41a7e4bcda78e56b55e3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "322db6d164eeb7021a1987bdb0333e4c91dcfffbf70c67e9e6d71a1afa91b344"
  end

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
diff --git a/modules/smc/core/log.scm b/modules/smc/core/log.scm
index c2062fa..b94b0e0 100644
--- a/modules/smc/core/log.scm
+++ b/modules/smc/core/log.scm
@@ -45,10 +45,10 @@

 (define (log level fmt . args)
   (let* ((message (apply format #f fmt args))
-         (command (format #f "~a ~a --priority=user.~a --tag='~a' '~a'"
+         (command (format #f "~a ~a -p 'user.~a' -t '~a' '~a'"
                           %logger
                           (if *use-stderr?*
-                              "--stderr"
+                              "-s"
                               "")
                           level
                           %tag
