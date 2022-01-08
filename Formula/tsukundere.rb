class Tsukundere < Formula
  desc "Engine to create visual novels using GNU Guile"
  homepage "https://gitlab.com/lilyp/tsukundere"
  url "https://gitlab.com/lilyp/tsukundere/-/archive/0.4.2/tsukundere-0.4.2.tar.gz"
  sha256 "ac4cdabd448b389154e0e392e620340c3e5da8a23e205c855fa36fa4b506d7ba"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/tsukundere-0.4.2_2"
    sha256 big_sur:      "10d885fd71ffac695ae330a8f55bade33177c681b4994ecbb8bb32be4977bb2d"
    sha256 x86_64_linux: "404e02e3d9ca542ad5a8fdf76e7d2b51f7986cba25517f1251b6fa1a2cace9bb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-sdl2"
  depends_on "pango"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    # patch doesn't actually perform the rename on macOS, so we have to do it
    # ourselves.
    if OS.mac?
      mv buildpath/"baka/markup.scm.in", buildpath/"baka/markup.scm"
      mv buildpath/"baka/text.scm.in", buildpath/"baka/text.scm"
    end

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
    tsukundere = testpath/"tsukundere.scm"
    tsukundere.write <<~EOS
      (use-modules (tsukundere))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", tsukundere
  end
end

__END__
diff --git a/.gitignore b/.gitignore
index 4ab2f63..19d6115 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,8 +20,6 @@ public
 doc/version.texi
 doc/snarf
 pre-inst-env
-baka/markup.scm
-baka/text.scm
 tsukundere/i18n.scm
 .deps
 .libs
diff --git a/baka/markup.scm.in b/baka/markup.scm
similarity index 90%
rename from baka/markup.scm.in
rename to baka/markup.scm
index 65a2f0e..ef606b5 100644
--- a/baka/markup.scm.in
+++ b/baka/markup.scm
@@ -21,11 +21,7 @@
   #:export (parse-markup append-markup))
 
 (eval-when (compile load eval)
-  (load-extension
-   (if (getenv "LIBBAKA_UNINSTALLED")
-       "libbaka.so"
-       "@tsukundere_extensiondir@/libbaka.so")
-   "baka_init_scm_markup"))
+  (load-extension "libbaka" "baka_init_scm_markup"))
 
 ;; Split @var{markup} into text and attributes, appending the former to
 ;; @var{text} and the latter to @var{attributes}.
diff --git a/baka/text.scm.in b/baka/text.scm
similarity index 98%
rename from baka/text.scm.in
rename to baka/text.scm
index 11cb4db..d0b5e24 100644
--- a/baka/text.scm.in
+++ b/baka/text.scm
@@ -41,11 +41,7 @@
             add-font-dir!))
 
 (eval-when (compile load eval)
-  (load-extension
-   (if (getenv "LIBBAKA_UNINSTALLED")
-       "libbaka.so"
-       "@tsukundere_extensiondir@/libbaka.so")
-   "baka_init_scm_text"))
+  (load-extension "libbaka" "baka_init_scm_text"))
 
 (define %double4 (list double double double double))
 (define %paint-options-structure (list int int %double4 %double4 double))
diff --git a/configure.ac b/configure.ac
index 1a4bbb9..f8f8039 100644
--- a/configure.ac
+++ b/configure.ac
@@ -60,7 +60,6 @@ PKG_CHECK_MODULES(PANGOCAIRO, [pangocairo])
 PKG_CHECK_MODULES(SDL2, [sdl2])
 
 AC_CONFIG_FILES([Makefile po/Makefile.in
-                 baka/markup.scm baka/text.scm
                  tsukundere/i18n.scm])
 AC_CONFIG_FILES([pre-inst-env], [chmod +x pre-inst-env])
 
diff --git a/pre-inst-env.in b/pre-inst-env.in
index 75ba9fd..7200f16 100644
--- a/pre-inst-env.in
+++ b/pre-inst-env.in
@@ -27,8 +27,7 @@ export GUILE_EXTENSIONS_PATH GUILE_LOAD_COMPILED_PATH GUILE_LOAD_PATH
 GUILE_AUTO_COMPILE=0
 export GUILE_AUTO_COMPILE
 
-LIBBAKA_UNINSTALLED=1
 TSUKUNDERE_UNINSTALLED=1
-export LIBBAKA_UNINSTALLED TSUKUNDERE_UNINSTALLED
+export TSUKUNDERE_UNINSTALLED
 
 exec "$@"
diff --git a/tsukundere/game.scm b/tsukundere/game.scm
index 4f7b357..2ae4b49 100644
--- a/tsukundere/game.scm
+++ b/tsukundere/game.scm
@@ -337,17 +337,18 @@ in the 'text layer using SPEAKER_FONT and TEXT_FONT respectively."
       (when locale-dir
         (bindtextdomain game-name locale-dir))))
 
-  (load-preferences)
-  (save-preferences #f 'unless-exists?)
-  (and=> (current-game) load-preferences)
-
-  (fluid-set! *save-state* save)
   (sdl-init)
   (set-hint! 'render-scale-quality 2)
   (when use-mixer?
     (init-sound! #:mixer-formats mixer-formats
                  #:mixer-frequency mixer-frequency
                  #:mixer-chunk-size mixer-chunk-size))
+
+  (load-preferences)
+  (save-preferences #f 'unless-exists?)
+  (and=> (current-game) load-preferences)
+
+  (fluid-set! *save-state* save)
   (call-with-window (make-window #:title window-title
                                  #:size (list window-width window-height)
                                  #:resizable? #t
-- 
2.34.1

