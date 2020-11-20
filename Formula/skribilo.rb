class Skribilo < Formula
  desc "Ultimate Document Programming Framework"
  homepage "https://www.nongnu.org/skribilo/"
  url "https://download.savannah.nongnu.org/releases/skribilo/skribilo-0.9.5.tar.gz"
  sha256 "00826a21c4634fb0b410ee89eb48068c445d800825874654e3d53d5ca3f0bf09"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnu-sed" => :build
  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-reader"
  depends_on "imagemagick"
  depends_on "lout"
  depends_on "ploticus"

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
    skribilo = testpath/"skribilo.scm"
    skribilo.write <<~EOS
      (use-modules (skribilo engine))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", skribilo
  end
end

__END__
diff --git a/substitute.am b/substitute.am
index 4f69cb8..7b481e9 100644
--- a/substitute.am
+++ b/substitute.am
@@ -4,7 +4,7 @@ AM_V_SUBSTITUTE = $(AM_V_SUBSTITUTE_$(V))
 AM_V_SUBSTITUTE_ = $(AM_V_SUBSTITUTE_$(AM_DEFAULT_VERBOSITY))
 AM_V_SUBSTITUTE_0 = @echo "  SUBSTITUTE" $@;

-substitute = sed -e 's,[@]guilemoduledir[@],$(guilemoduledir),g'	\
+substitute = gsed -e 's,[@]guilemoduledir[@],$(guilemoduledir),g'	\
 		 -e 's,[@]guileobjectdir[@],$(guileobjectdir),g'	\
 		 -e 's,[@]abs_top_srcdir[@],$(abs_top_srcdir),g'	\
 		 -e 's,[@]abs_top_builddir[@],$(abs_top_builddir),g'	\
diff --git a/configure.ac b/configure.ac
index 04c7eac..b0f08e8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@

 AC_PREREQ(2.59)
 AC_INIT([Skribilo],
-        m4_esyscmd([build-aux/git-version-gen .tarball-version]),
+        [0.9.5],
         [skribilo-users@nongnu.org],
 	[skribilo],
 	[https://nongnu.org/skribilo/])
