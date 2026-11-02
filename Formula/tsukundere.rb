class Tsukundere < Formula
  desc "Engine to create visual novels using GNU Guile"
  homepage "https://gitlab.com/lilyp/tsukundere"
  url "https://gitlab.com/lilyp/tsukundere/-/archive/0.4.3/tsukundere-0.4.3.tar.gz"
  sha256 "1b3b56b56ff13c683ff2cc048e7686ea3220126bf82da9d73ad425faeaba32f8"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/tsukundere-0.4.2_2"
    sha256 big_sur: "10d885fd71ffac695ae330a8f55bade33177c681b4994ecbb8bb32be4977bb2d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "guile"
  depends_on "guile-sdl2"
  depends_on "pango"
  depends_on "sdl2"

  on_macos do
    depends_on "bdw-gc"
  end

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"
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
