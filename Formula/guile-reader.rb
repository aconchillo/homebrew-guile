class GuileReader < Formula
  desc "Simple framework for building readers for GNU Guile"
  homepage "https://www.nongnu.org/guile-reader/"
  url "https://download.savannah.nongnu.org/releases/guile-reader/guile-reader-0.6.3.tar.gz"
  sha256 "38c2b444eadbb8c0cab78d90a44ec3ebff42bd410c5b84a91018cee7eb64d2bb"
  revision 1

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "gperf" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "lightning"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    ENV["PATH"] = "#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:#{ENV["PATH"]}"

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
    reader = testpath/"reader.scm"
    reader.write <<~EOS
      (use-modules (system reader))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", reader
  end
end

__END__
diff --git a/doc/Makefile.am b/doc/Makefile.am
index faa7016..ecca1de 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -28,6 +28,8 @@ BUILT_SOURCES = version.texi					\

 CLEANFILES = $(BUILT_SOURCES)

+version.texi: stamp-vti
+
 token-reader-doc.texi reader-lib-doc.texi: $(top_srcdir)/src/token-readers.h
 	main='(module-ref (resolve-module '\''(extract-doc)) '\'main')' &&	\
 	GUILE_AUTO_COMPILE=0							\
