class GuileIni < Formula
  desc "GNU Guile library for working with INI format"
  homepage "https://github.com/artyom-poptsov/guile-ini"
  url "https://github.com/artyom-poptsov/guile-ini/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "728f5c5bbcc68df043fbd69763e4197020a18932c0a6798b75149563f0d83060"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ini-0.4.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "ad29ae24502e4c1f7ebf97b0c879c92e4e35c4b973fbbb1ac688fae26f10b81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e716af146ff3751e0c89c90a63560fb3f2107a0100d3661c018101bee72511c0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
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
diff --git a/modules/ini/Makefile.am b/modules/ini/Makefile.am
index 5b5d20b..533c2b1 100644
--- a/modules/ini/Makefile.am
+++ b/modules/ini/Makefile.am
@@ -20,12 +20,16 @@
 include $(top_srcdir)/build-aux/am/guile.am

 SOURCES = \
-	fsm-context.scm \
 	fsm.scm	\
 	fsm-context-ini.scm

+BUILT_SOURCES = \
+	fsm-context.scm
+
+INSTALL += \
+	fsm-context.scm
+
 EXTRA_DIST += \
-	fsm-context.scm \
 	fsm.scm	\
 	fsm.puml
