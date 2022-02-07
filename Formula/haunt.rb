class Haunt < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/haunt/haunt-0.2.6.tar.gz"
  sha256 "bcf28b43d84325d8a61005f02011a045195e7ccf3fefbc4542823ed09fe590db"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/haunt-0.2.6_1"
    sha256 cellar: :any_skip_relocation, big_sur:      "f81c048772ac3c52a6c9bc5e6279b371525c3d8b7f5608bd2c7428950e037d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4504b0bb959ec1d71307ee32039fb61c20bfea728e9334a8069784042db7a103"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-commonmark"
  depends_on "guile-reader"

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
    haunt = testpath/"haunt.scm"
    haunt.write <<~EOS
      (use-modules (haunt site))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", haunt
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index e3eb96f..1bddaa4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -46,7 +46,6 @@ bin_SCRIPTS =					\
 SOURCES =					\
   haunt/config.scm				\
   haunt/utils.scm				\
-  haunt/inotify.scm				\
   haunt/post.scm				\
   haunt/page.scm				\
   haunt/asset.scm				\
@@ -81,6 +80,12 @@ SOURCES +=					\

 endif

+if HAVE_INOTIFY
+
+SOURCES += haunt/inotify.scm
+
+endif
+
 TESTS =						\
   tests/helper.scm				\
   tests/post.scm				\
diff --git a/configure.ac b/configure.ac
index bb9550c..2a80cdf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,4 +21,7 @@ AM_CONDITIONAL([HAVE_GUILE_READER], [test "x$have_guile_reader" = "xyes"])
 GUILE_MODULE_AVAILABLE([have_guile_commonmark], [(commonmark)])
 AM_CONDITIONAL([HAVE_GUILE_COMMONMARK], [test "x$have_guile_commonmark" = "xyes"])

+AC_CHECK_FUNCS(inotify_init)
+AM_CONDITIONAL([HAVE_INOTIFY], [test "x$HAVE_INOTIFY_INIT" = "xyes"])
+
 AC_OUTPUT
diff --git a/haunt/ui/serve.scm b/haunt/ui/serve.scm
index 62fbc6b..8511d87 100644
--- a/haunt/ui/serve.scm
+++ b/haunt/ui/serve.scm
@@ -30,7 +30,6 @@
   #:use-module (ice-9 ftw)
   #:use-module (ice-9 threads)
   #:use-module (haunt config)
-  #:use-module (haunt inotify)
   #:use-module (haunt serve web-server)
   #:use-module (haunt site)
   #:use-module (haunt ui)
@@ -90,6 +89,17 @@ Start an HTTP server for the current site.~%")

 ;; TODO: Detect new directories and watch them, too.
 (define (watch/linux config-file check-dir? check-file?)
+  ;; Lazy load inotify procedures.  Requiring the module in the
+  ;; define-module definition would cause crashes on non-Linux
+  ;; platforms where the FFI cannot bind to inotify functions.
+  (define make-inotify (@ (haunt inotify) make-inotify))
+  (define inotify-add-watch! (@ (haunt inotify) inotify-add-watch!))
+  (define inotify-pending-events? (@ (haunt inotify) inotify-pending-events?))
+  (define inotify-read-event (@ (haunt inotify) inotify-read-event))
+  (define inotify-watch-file-name (@ (haunt inotify) inotify-watch-file-name))
+  (define inotify-event-watch (@ (haunt inotify) inotify-event-watch))
+  (define inotify-event-file-name (@ (haunt inotify) inotify-event-file-name))
+  (define inotify-event-type (@ (haunt inotify) inotify-event-type))
   (let ((inotify (make-inotify)))
     (define (no-op name stat result) result)
     (define (watch-directory name stat result)
diff --git a/configure.ac b/configure.ac
index 2a80cdf..da381d3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,7 +21,6 @@ AM_CONDITIONAL([HAVE_GUILE_READER], [test "x$have_guile_reader" = "xyes"])
 GUILE_MODULE_AVAILABLE([have_guile_commonmark], [(commonmark)])
 AM_CONDITIONAL([HAVE_GUILE_COMMONMARK], [test "x$have_guile_commonmark" = "xyes"])

-AC_CHECK_FUNCS(inotify_init)
-AM_CONDITIONAL([HAVE_INOTIFY], [test "x$HAVE_INOTIFY_INIT" = "xyes"])
+AC_CHECK_FUNC([inotify_init], [AM_CONDITIONAL(HAVE_INOTIFY, true)], [AM_CONDITIONAL(HAVE_INOTIFY, false)])

 AC_OUTPUT
diff --git a/haunt/ui/serve.scm b/haunt/ui/serve.scm
index 8511d87..8abe0c6 100644
--- a/haunt/ui/serve.scm
+++ b/haunt/ui/serve.scm
@@ -89,17 +89,21 @@ Start an HTTP server for the current site.~%")

 ;; TODO: Detect new directories and watch them, too.
 (define (watch/linux config-file check-dir? check-file?)
-  ;; Lazy load inotify procedures.  Requiring the module in the
+  ;; Lazy load inotify module.  Requiring the module in the
   ;; define-module definition would cause crashes on non-Linux
   ;; platforms where the FFI cannot bind to inotify functions.
-  (define make-inotify (@ (haunt inotify) make-inotify))
-  (define inotify-add-watch! (@ (haunt inotify) inotify-add-watch!))
-  (define inotify-pending-events? (@ (haunt inotify) inotify-pending-events?))
-  (define inotify-read-event (@ (haunt inotify) inotify-read-event))
-  (define inotify-watch-file-name (@ (haunt inotify) inotify-watch-file-name))
-  (define inotify-event-watch (@ (haunt inotify) inotify-event-watch))
-  (define inotify-event-file-name (@ (haunt inotify) inotify-event-file-name))
-  (define inotify-event-type (@ (haunt inotify) inotify-event-type))
+  (define inotify-module (resolve-module '(haunt inotify)))
+  (define make-inotify (module-ref inotify-module 'make-inotify))
+  (define inotify-add-watch! (module-ref inotify-module 'inotify-add-watch!))
+  (define inotify-pending-events?
+    (module-ref inotify-module 'inotify-pending-events?))
+  (define inotify-read-event (module-ref inotify-module 'inotify-read-event))
+  (define inotify-watch-file-name
+    (module-ref inotify-module 'inotify-watch-file-name))
+  (define inotify-event-watch (module-ref inotify-module 'inotify-event-watch))
+  (define inotify-event-file-name
+    (module-ref inotify-module 'inotify-event-file-name))
+  (define inotify-event-type (module-ref inotify-module 'inotify-event-type))
   (let ((inotify (make-inotify)))
     (define (no-op name stat result) result)
     (define (watch-directory name stat result)
