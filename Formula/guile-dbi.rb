class GuileDbi < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi.git", revision: "56e12dcab139c373dafccdd72fa2a140d82f3910"
  version "2.1.9"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbi-2.1.8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f18cbb0ce8634b335353110e20636547c3ce3d35f83c4bc99a254d4551d78be"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chdir "guile-dbi" do
      system "autoreconf", "-vif"
      system "./configure", "--prefix=#{prefix}",
             "--with-guile-site-dir=#{share}/guile/site/3.0"
      system "make", "install"
    end
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
    dbi = testpath/"dbi.scm"
    dbi.write <<~EOS
      (use-modules (dbi dbi))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dbi
  end
end

__END__
diff --git a/guile-dbi/configure.ac b/guile-dbi/configure.ac
index 0b7d97f..71994e4 100644
--- a/guile-dbi/configure.ac
+++ b/guile-dbi/configure.ac
@@ -56,10 +56,6 @@ PKG_CHECK_MODULES([GUILE], [guile-3.0])
 GUILE_PKG([3.0])
 GUILE_FLAGS
 GUILE_SITE_DIR
-#--
-CFLAGS="${CFLAGS} ${LTDLINCL} `$GUILE_CONFIG compile`"
-LIBS="$LIBLTDL `$GUILE_CONFIG link`"
-GUILE_SITE=`$GUILE_CONFIG info sitedir`

 # Check for makeinfo; avoid ugliness if not installed.
 AC_CHECK_PROG(have_makeinfo,makeinfo,yes,no)
diff --git a/guile-dbi/src/dbi/Makefile.am b/guile-dbi/src/dbi/Makefile.am
index fe05315..342f567 100644
--- a/guile-dbi/src/dbi/Makefile.am
+++ b/guile-dbi/src/dbi/Makefile.am
@@ -24,7 +24,7 @@
 
 AUTOMAKE_OPTIONS = gnu
 
-guiledbidatadir = $(GUILE_SITE)/dbi
+guiledbidatadir = $(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/dbi
 guiledbidata_DATA = dbi.scm
 
 EXTRA_DIST = $(guiledbidata_DATA)
