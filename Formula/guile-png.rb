class GuilePng < Formula
  desc "Portable Network Graphics library for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-png"
  url "https://github.com/artyom-poptsov/guile-png/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b8b1a046461033d85f55cc4f7946faf1d20a0c62baaf280fa7083df144f9236f"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "guile-zlib"

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
    png = testpath/"png.scm"
    png.write <<~EOS
      (use-modules (png) (png image))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", png
  end
end

__END__
diff --git a/modules/Makefile.am b/modules/Makefile.am
index 0ab8a6f..05788ce 100644
--- a/modules/Makefile.am
+++ b/modules/Makefile.am
@@ -17,16 +17,16 @@
 ## You should have received a copy of the GNU General Public License
 ## along with Guile-PNG.  If not, see <http://www.gnu.org/licenses/>.
 
-include $(top_srcdir)/build-aux/am/guilec
+include $(top_srcdir)/build-aux/am/guile.am
 
 SUBDIRS = \
-	png	\
+	png \
 	.
 
 SOURCES = \
 	png.scm
 
-moddir=$(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)/
-godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)
+godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
 
 ### Makefile.am ends here.
diff --git a/modules/png/Makefile.am b/modules/png/Makefile.am
index 5b0dc81..97a52ed 100644
--- a/modules/png/Makefile.am
+++ b/modules/png/Makefile.am
@@ -30,12 +30,12 @@ SOURCES = \
 	image-processing.scm	\
 	graphics.scm
 
-moddir=$(guilesitedir)/png/
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/png
 nobase_dist_mod_DATA = \
 	$(SOURCES) \
 	$(EXTRA_DIST)
 
-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png
 nobase_nodist_ccache_DATA = $(GOBJECTS)
 
 # Make sure source files are installed first, so that the mtime of
diff --git a/modules/png/core/Makefile.am b/modules/png/core/Makefile.am
index a8d1ac7..5dbb13d 100644
--- a/modules/png/core/Makefile.am
+++ b/modules/png/core/Makefile.am
@@ -37,11 +37,11 @@ SOURCES = \
 
 GOBJECTS = $(SOURCES:%.scm=%.go)
 
-moddir=$(guilesitedir)/png/core/
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/png/core
 nobase_dist_mod_DATA = \
 	$(SOURCES)
 
-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/core/
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/core
 nobase_nodist_ccache_DATA = $(GOBJECTS)
 
 # Make sure source files are installed first, so that the mtime of
diff --git a/modules/png/fsm/Makefile.am b/modules/png/fsm/Makefile.am
index b57b2fb..0529704 100644
--- a/modules/png/fsm/Makefile.am
+++ b/modules/png/fsm/Makefile.am
@@ -25,21 +25,26 @@ SOURCES = \
 	signature-context.scm
 
 BUILT_SOURCES =	\
-	context.scm
+	context.scm \
+	png-parser.scm \
+	chunk-parser.scm \
+	signature-parser.scm
+
+INSTALL += \
+	context.scm \
+	png-parser.scm \
+	chunk-parser.scm \
+	signature-parser.scm
 
 EXTRA_DIST += \
 	chunk-parser.puml \
-	chunk-parser.scm \
 	png-parser.puml \
-	png-parser.scm	\
-	signature-parser.puml \
-	signature-parser.scm
+	signature-parser.puml
 
-INSTALL += \
-	context.scm
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/png/fsm
+godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/fsm
 
-moddir=$(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)/png/fsm/
-godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/fsm/
+SUFFIXES = .puml
 
 GUILE_SMC_CONTEXT_ARGS = \
 	--log-driver file \
@@ -86,8 +91,6 @@ endif
 
 GUILE_SMC_ENV = GUILE_AUTO_COMPILE=0
 
-all: context.scm png-parser.scm
-
 context.scm:
 	@echo "  SMC      $@"
 	@$(GUILE_SMC_ENV) smc context $(GUILE_SMC_CONTEXT_ARGS) > $@
diff --git a/modules/png/graphics/Makefile.am b/modules/png/graphics/Makefile.am
index 4f4cc4a..47797b3 100644
--- a/modules/png/graphics/Makefile.am
+++ b/modules/png/graphics/Makefile.am
@@ -31,11 +31,11 @@ SOURCES = \
 
 GOBJECTS = $(SOURCES:%.scm=%.go)
 
-moddir=$(guilesitedir)/png/core/
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/png/graphics
 nobase_dist_mod_DATA = \
 	$(SOURCES)
 
-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/graphics/
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/png/graphics
 nobase_nodist_ccache_DATA = $(GOBJECTS)
 
 # Make sure source files are installed first, so that the mtime of
