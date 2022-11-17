class GuileDeck < Formula
  desc "Matrix network SDK for Guile"
  homepage "https://github.com/artyom-poptsov/guile-deck"
  url "https://github.com/artyom-poptsov/guile-deck/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a2b3a5cd7626010abef1ec217f8a70dac0eea734d0aa6e34a3f5819b4eaafe4b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-deck-0.2.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5a0fc318125b34e30346cac6e30d3da6cb0ebe217fa17b6126e51e21dfaca3f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "gnutls"
  depends_on "guile"
  depends_on "guile-gcrypt"
  depends_on "guile-json"

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
    deck = testpath/"deck.scm"
    deck.write <<~EOS
      (use-modules (deck matrix))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", deck
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index c4714d3..7e5641d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -43,7 +43,7 @@ AC_ARG_WITH([guilesitedir],
              esac],
              [guilesitedir=""])
 
-GUILE_PKG([2.2])
+GUILE_PKG([3.0 2.2])
 GUILE_PROGS
 GUILE_SITE_DIR
 
diff --git a/examples/Makefile.am b/examples/Makefile.am
index cf540a6..6d4fb29 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -17,16 +17,14 @@
 ## <http://www.gnu.org/licenses/>.
 
 bin_SCRIPTS = hello-bot.scm send-message.scm
-hello_bot_scm_SOURCES = hello-bot.scm.in
-send_message_scm_SOURCES = send-message.scm.in
 
 EXTRA_DIST = \
 	hello-bot.scm.in	\
 	send-message.scm.in
 
-SOURCES = \
-	hello-bot.scm.in	\
-	send-message.scm.in
+BUILT_SOURCES = \
+	hello-bot.scm	\
+	send-message.scm
 
 examplesdir = $(pkgdatadir)/examples
 dist_examples_DATA = \
@@ -45,4 +43,3 @@ SUFFIXES = .in
 
 CLEANFILES = \
 	$(bin_SCRIPTS)
-
diff --git a/modules/deck/Makefile.am b/modules/deck/Makefile.am
index f5cc137..6d43c01 100644
--- a/modules/deck/Makefile.am
+++ b/modules/deck/Makefile.am
@@ -25,10 +25,10 @@ SOURCES = matrix.scm matrix-client.scm
 
 GOBJECTS = $(SOURCES:%.scm=%.go)
 
-moddir=$(guilesitedir)/deck/
+moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/deck
 nobase_dist_mod_DATA = $(SOURCES)
 
-ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
+ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/deck
 nobase_nodist_ccache_DATA = $(GOBJECTS)
 
 # Make sure source files are installed first, so that the mtime of
