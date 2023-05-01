class GuileCairo < Formula
  desc "Guile wrapper for the Cairo graphics library"
  homepage "https://www.nongnu.org/guile-cairo/"
  url "https://download.savannah.gnu.org/releases/guile-cairo/guile-cairo-1.11.2.tar.gz"
  sha256 "6232d4dc2c5bd9d331139b3b01f4343c3e1fb9ca7898361a699206730941a07b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-cairo-1.11.1_1"
    sha256 big_sur:      "c4bd0f8ae420eb27bb8f761442dbde51022bc7d789681250e2dfa9100732a07e"
    sha256 x86_64_linux: "dedd582916ff5bccf18c50ae8fd46ccb8fd09c6ff7d3c361b6099a4e8658816e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/cairo/config.go"
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
    cairo = testpath/"cairo.scm"
    cairo.write <<~EOS
      (use-modules (cairo))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", cairo
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index aaf2507..94cd012 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -28,9 +28,20 @@ ACLOCAL_AMFLAGS = -I m4

 CLEANFILES = env

-scmdir=$(prefix)/share/guile/site
+GOBJECTS = $(SOURCES:%.scm=%.go)

-scm_DATA = cairo.scm
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)
+objdir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
+
+nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
+nobase_nodist_obj_DATA = $(GOBJECTS)
+
+GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
+SUFFIXES = .scm .go
+.scm.go:
+	$(top_builddir)/env $(GUILD) compile $(GUILE_TARGET) $(GUILE_WARNINGS) -o "$@" "$<"
+
+SOURCES = cairo.scm

 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = guile-cairo.pc
diff --git a/cairo/Makefile.am b/cairo/Makefile.am
index f4959af..05b5973 100644
--- a/cairo/Makefile.am
+++ b/cairo/Makefile.am
@@ -15,29 +15,26 @@
 # License along with this program.  If not, see
 # <http://www.gnu.org/licenses/>.

-all-local: config.scm
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/cairo
+objdir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/cairo

-lib_builddir = $(shell cd $(top_builddir)/guile-cairo && pwd)
-docs_builddir = $(shell cd $(top_builddir)/doc && pwd)
+SOURCES = config.scm vector-types.scm
+NOCOMP_SOURCES = cairo-procedures.txt

-moduledir=$(prefix)/share/guile/site/cairo
+GOBJECTS = $(SOURCES:%.scm=%.go)

-module_DATA = vector-types.scm cairo-procedures.txt
+nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
+nobase_nodist_obj_DATA = $(GOBJECTS)

-config.scm: Makefile config.scm.in
-	sed -e "s|@cairolibpath\@|$(lib_builddir)/libguile-cairo|" \
-	    -e "s|@cairodocumentationpath\@|$(docs_builddir)/cairo-procedures.txt|" \
-	    $(srcdir)/config.scm.in > config.scm
+GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
+SUFFIXES = .scm .go
+.scm.go:
+	$(top_builddir)/env $(GUILD) compile $(GUILE_TARGET) $(GUILE_WARNINGS) -o "$@" "$<"

-install-data-local: Makefile config.scm.in
-	$(mkinstalldirs) $(DESTDIR)$(moduledir)
+config.scm: Makefile config.scm.in
 	sed -e "s|@cairolibpath\@|$(libdir)/libguile-cairo|" \
-	    -e "s|@cairodocumentationpath\@|$(moduledir)/cairo-procedures.txt|" \
-	    $(srcdir)/config.scm.in > $(DESTDIR)$(moduledir)/config.scm
-	chmod 644 $(DESTDIR)$(moduledir)/config.scm
-
-uninstall-local:
-	rm -f $(DESTDIR)$(moduledir)/config.scm
+	    -e "s|@cairodocumentationpath\@|$(moddir)/cairo-procedures.txt|" \
+	    $(srcdir)/config.scm.in > config.scm

 cairo-procedures.txt.update:
 	echo "Generated from upstream documentation; see COPYING.docs for info." \
@@ -45,6 +42,6 @@ cairo-procedures.txt.update:
 	$(top_srcdir)/doc/docbook-to-guile-doc $(CAIRO_XML_DIR)/*.xml \
 	  >> $(srcdir)/cairo-procedures.txt

-CLEANFILES = config.scm
+CLEANFILES = config.scm $(GOBJECTS)

-EXTRA_DIST = config.scm.in $(module_DATA)
+EXTRA_DIST = config.scm.in
diff --git a/configure.ac b/configure.ac
index 31a3367..78b7414 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,9 +77,15 @@ AC_SUBST(AM_LDFLAGS)
 # Check for Guile
 #
 GUILE_PKG
+GUILE_PROGS
 GUILE_FLAGS
 AC_SUBST(GUILE_EFFECTIVE_VERSION)

+if test "$cross_compiling" != no; then
+   GUILE_TARGET="--target=$host_alias"
+   AC_SUBST([GUILE_TARGET])
+fi
+
 PKG_CHECK_MODULES(CAIRO, cairo >= 1.10.0)
 AC_SUBST(CAIRO_LIBS)
 AC_SUBST(CAIRO_CFLAGS)
diff --git a/guile-cairo/guile-cairo.c b/guile-cairo/guile-cairo.c
index b298fc8..ed75981 100644
--- a/guile-cairo/guile-cairo.c
+++ b/guile-cairo/guile-cairo.c
@@ -1,6 +1,9 @@
 /* guile-cairo
  * Copyright (C) 2007, 2011, 2012, 2014, 2018, 2020 Andy Wingo <wingo at pobox dot com>
- *
+ * Copyright (C) 2023 Daniel Llorens <lloda at sarc dot name>
+ * Copyright (C) 2023 Dale Smith <dalepsmith at gmail dot com>
+ * Copyright (C) 2023 David Pirotte <david at altosw dot be>
+
  * guile-cairo.c: Cairo for Guile
  *
  * This library is free software; you can redistribute it and/or modify
@@ -3523,6 +3526,19 @@ cairo_svg_version_to_string (cairo_svg_version_t version);
 #endif /* CAIRO_HAS_SVG_SURFACE */
 
 
+SCM_DEFINE_PUBLIC (scm_context2cairo_pointer, "context->cairo-pointer", 1, 0, 0,
+                   (SCM scr),
+                   "")
+{
+  return scm_from_pointer (scm_to_cairo (scr), NULL);
+}
+
+SCM_DEFINE_PUBLIC (scm_cairo_pointer2context, "cairo-pointer->context", 1, 0, 0,
+                   (SCM scr),
+                   "")
+{
+  return scm_from_cairo ((cairo_t *) scm_to_pointer (scr));
+}
 
 void
 scm_init_cairo (void)
diff --git a/tests/unit-tests/Makefile.am b/tests/unit-tests/Makefile.am
index c13443d..9bf2316 100644
--- a/tests/unit-tests/Makefile.am
+++ b/tests/unit-tests/Makefile.am
@@ -1,5 +1,6 @@
 # guile-cairo
 # Copyright (C) 2007,2011  Andy Wingo <wingo@pobox.com>
+# Copyright (C) 2023  David Pirotte <david@altosw.be>
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as
@@ -16,8 +17,9 @@
 # <http://www.gnu.org/licenses/>.
 
 TESTS= \
-	api-stability.scm \
-	version.scm
+	api-stability.scm	\
+	version.scm		\
+	context-pointer.scm
 
 TESTS_ENVIRONMENT=\
 	API_FILE=$(srcdir)/cairo.api $(top_builddir)/env guile -s
diff --git a/tests/unit-tests/context-pointer.scm b/tests/unit-tests/context-pointer.scm
new file mode 100644
index 0000000..a352c3e
--- /dev/null
+++ b/tests/unit-tests/context-pointer.scm
@@ -0,0 +1,29 @@
+;; guile-cairo unit test
+;; Copyright (C) 2023  David Pirotte <david@altosw.be>
+
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 3 of the License, or (at
+;; your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful, but
+;; WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+;; General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, see <http://www.gnu.org/licenses/>.
+
+(use-modules (unit-test)
+             (oop goops)
+             (cairo))
+
+(define-class <test-context-pointer> (<test-case>))
+
+(define-method (test-context-pointer (self <test-context-pointer>))
+  (let* ((cs (cairo-image-surface-create 'argb32 140 100))
+         (cr (cairo-create cs)))
+    (assert (context->cairo-pointer cr))
+    (assert (cairo-pointer->context (context->cairo-pointer cr)))))
+
+(exit-with-summary (run-all-defined-test-cases))
diff --git a/configure.ac b/configure.ac
index 7ab3f24..274d825 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AM_INIT_AUTOMAKE([1.14 gnu -Wno-portability -Wno-syntax \
 AM_MAINTAINER_MODE([enable])
 AM_SILENT_RULES([yes])
 
-AC_SUBST(VERSION, 1.11.2)
+AC_SUBST(VERSION, 1.12.0)
 
 AC_ISC_POSIX
 AC_PROG_CC
diff --git a/guile-cairo/guile-cairo.c b/guile-cairo/guile-cairo.c
index ed75981..05ce7b3 100644
--- a/guile-cairo/guile-cairo.c
+++ b/guile-cairo/guile-cairo.c
@@ -3526,7 +3526,7 @@ cairo_svg_version_to_string (cairo_svg_version_t version);
 #endif /* CAIRO_HAS_SVG_SURFACE */
 
 
-SCM_DEFINE_PUBLIC (scm_context2cairo_pointer, "context->cairo-pointer", 1, 0, 0,
+SCM_DEFINE_PUBLIC (scm_cairo_context2pointer, "cairo-context->pointer", 1, 0, 0,
                    (SCM scr),
                    "")
 {
diff --git a/tests/unit-tests/Makefile.am b/tests/unit-tests/Makefile.am
index 9bf2316..3ba6af9 100644
--- a/tests/unit-tests/Makefile.am
+++ b/tests/unit-tests/Makefile.am
@@ -17,9 +17,9 @@
 # <http://www.gnu.org/licenses/>.
 
 TESTS= \
+	context-pointer.scm \
 	api-stability.scm	\
-	version.scm		\
-	context-pointer.scm
+	version.scm
 
 TESTS_ENVIRONMENT=\
 	API_FILE=$(srcdir)/cairo.api $(top_builddir)/env guile -s
diff --git a/tests/unit-tests/cairo.api b/tests/unit-tests/cairo.api
index d22ca87..8e83807 100644
--- a/tests/unit-tests/cairo.api
+++ b/tests/unit-tests/cairo.api
@@ -7,14 +7,22 @@
   cairo-clip-preserve
   cairo-close-path
   cairo-content-get-values
+  cairo-context->pointer
   cairo-copy-clip-rectangle-list
   cairo-copy-page
   cairo-copy-path
   cairo-copy-path-flat
   cairo-create
   cairo-curve-to
+  cairo-destroy
+  cairo-device-acquire
+  cairo-device-finish
+  cairo-device-flush
+  cairo-device-get-type
+  cairo-device-release
   cairo-device-to-user
   cairo-device-to-user-distance
+  cairo-device-type-get-values
   cairo-extend-get-values
   cairo-fill
   cairo-fill-extents
@@ -44,6 +52,7 @@
   cairo-font-type-get-values
   cairo-font-weight-get-values
   cairo-format-get-values
+  cairo-format-stride-for-width
   cairo-get-antialias
   cairo-get-current-point
   cairo-get-dash-count
@@ -67,15 +76,20 @@
   cairo-glyph:index
   cairo-glyph:x
   cairo-glyph:y
+  cairo-has-current-point
   cairo-hint-metrics-get-values
   cairo-hint-style-get-values
   cairo-identity-matrix
   cairo-image-surface-create
+  cairo-image-surface-create-for-data
   cairo-image-surface-create-from-png
+  cairo-image-surface-get-data
   cairo-image-surface-get-format
   cairo-image-surface-get-height
   cairo-image-surface-get-stride
   cairo-image-surface-get-width
+  cairo-image-surface-set-data
+  cairo-in-clip
   cairo-in-fill
   cairo-in-stroke
   cairo-line-cap-get-values
@@ -86,6 +100,7 @@
   cairo-make-identity-matrix
   cairo-make-matrix
   cairo-make-rectangle
+  cairo-make-rectangle-int
   cairo-make-rotate-matrix
   cairo-make-scale-matrix
   cairo-make-text-extents
@@ -94,6 +109,8 @@
   cairo-mask-surface
   cairo-matrix-invert
   cairo-matrix-multiply
+  cairo-matrix-rotate
+  cairo-matrix-scale
   cairo-matrix-transform-distance
   cairo-matrix-transform-point
   cairo-matrix-translate
@@ -104,6 +121,7 @@
   cairo-paint
   cairo-paint-with-alpha
   cairo-path-data-type-get-values
+  cairo-path-extents
   cairo-path-fold
   cairo-pattern-add-color-stop-rgb
   cairo-pattern-add-color-stop-rgba
@@ -126,22 +144,50 @@
   cairo-pattern-set-filter
   cairo-pattern-set-matrix
   cairo-pattern-type-get-values
+  cairo-pdf-get-versions
+  cairo-pdf-level-get-values
   cairo-pdf-surface-create
+  cairo-pdf-surface-restrict-to-version
   cairo-pdf-surface-set-size
+  cairo-pointer->context
   cairo-pop-group
   cairo-pop-group-to-source
+  cairo-ps-get-levels
+  cairo-ps-level-get-values
   cairo-ps-surface-begin-page-setup
   cairo-ps-surface-begin-setup
   cairo-ps-surface-create
   cairo-ps-surface-dsc-comment
+  cairo-ps-surface-get-eps
+  cairo-ps-surface-restrict-to-level
+  cairo-ps-surface-set-eps
   cairo-ps-surface-set-size
   cairo-push-group
   cairo-push-group-with-context
+  cairo-recording-surface-create
+  cairo-recording-surface-ink-extents
   cairo-rectangle
+  cairo-rectangle-int:height
+  cairo-rectangle-int:width
+  cairo-rectangle-int:x
+  cairo-rectangle-int:y
   cairo-rectangle:height
   cairo-rectangle:width
   cairo-rectangle:x
   cairo-rectangle:y
+  cairo-region-contains-point
+  cairo-region-contains-rectangle
+  cairo-region-copy
+  cairo-region-create
+  cairo-region-get-extents
+  cairo-region-get-rectangles
+  cairo-region-intersect
+  cairo-region-is-empty
+  cairo-region-overlap-get-values
+  cairo-region-subtract
+  cairo-region-translate
+  cairo-region-union
+  cairo-region-xor
   cairo-rel-curve-to
   cairo-rel-line-to
   cairo-rel-move-to
@@ -156,9 +202,11 @@
   cairo-scaled-font-get-font-face
   cairo-scaled-font-get-font-matrix
   cairo-scaled-font-get-font-options
+  cairo-scaled-font-get-scale_matrix
   cairo-scaled-font-get-type
   cairo-scaled-font-glyph-extents
   cairo-scaled-font-text-extents
+  cairo-scaled-font-text-to-glyphs
   cairo-select-font-face
   cairo-set-antialias
   cairo-set-dash
@@ -182,26 +230,38 @@
   cairo-show-glyphs
   cairo-show-page
   cairo-show-text
+  cairo-show-text-glyphs
+  cairo-status-get-values
   cairo-stroke
   cairo-stroke-extents
   cairo-stroke-preserve
   cairo-subpixel-order-get-values
+  cairo-surface-copy-page
+  cairo-surface-create-for-rectangle
   cairo-surface-create-similar
+  cairo-surface-destroy
   cairo-surface-finish
   cairo-surface-flush
   cairo-surface-get-content
+  cairo-surface-get-device
   cairo-surface-get-device-offset
+  cairo-surface-get-fallback-resolution
   cairo-surface-get-font-options
+  cairo-surface-get-mime-data
   cairo-surface-get-type
+  cairo-surface-has-show-text-glyphs
   cairo-surface-mark-dirty
   cairo-surface-mark-dirty-rectangle
   cairo-surface-set-device-offset
   cairo-surface-set-fallback-resolution
+  cairo-surface-set-mime-data
+  cairo-surface-show-page
   cairo-surface-type-get-values
   cairo-surface-write-to-png
   cairo-svg-surface-create
   cairo-svg-surface-restrict-to-version
   cairo-svg-version-get-values
+  cairo-text-cluster-flags-get-values
   cairo-text-extents
   cairo-text-extents:height
   cairo-text-extents:width
@@ -210,8 +270,17 @@
   cairo-text-extents:y-advance
   cairo-text-extents:y-bearing
   cairo-text-path
+  cairo-toy-font-face-create
+  cairo-toy-font-face-get-family
+  cairo-toy-font-face-get-slant
+  cairo-toy-font-face-get-weight
   cairo-transform
   cairo-translate
+  cairo-user-font-face-create
+  cairo-user-font-face-set-init-func
+  cairo-user-font-face-set-render-glyph-func
+  cairo-user-font-face-set-text-to-glyphs-func
+  cairo-user-font-face-set-unicode-to-glyph-func
   cairo-user-to-device
   cairo-user-to-device-distance
   cairo-version
diff --git a/tests/unit-tests/context-pointer.scm b/tests/unit-tests/context-pointer.scm
index a352c3e..397e083 100644
--- a/tests/unit-tests/context-pointer.scm
+++ b/tests/unit-tests/context-pointer.scm
@@ -23,7 +23,7 @@
 (define-method (test-context-pointer (self <test-context-pointer>))
   (let* ((cs (cairo-image-surface-create 'argb32 140 100))
          (cr (cairo-create cs)))
-    (assert (context->cairo-pointer cr))
-    (assert (cairo-pointer->context (context->cairo-pointer cr)))))
+    (assert (cairo-context->pointer cr))
+    (assert (cairo-pointer->context (cairo-context->pointer cr)))))
 
 (exit-with-summary (run-all-defined-test-cases))
