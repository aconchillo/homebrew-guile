class GuileReader < Formula
  desc "Simple framework for building readers for GNU Guile"
  homepage "https://www.nongnu.org/guile-reader/"
  url "https://download.savannah.nongnu.org/releases/guile-reader/guile-reader-0.6.3.tar.gz"
  sha256 "38c2b444eadbb8c0cab78d90a44ec3ebff42bd410c5b84a91018cee7eb64d2bb"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-reader-0.6.3_3"
    sha256 arm64_tahoe:   "26317ace35fca9ad95e2f8e5911c6167cc6007ef427bd76b74ca486eca144a56"
    sha256 arm64_sequoia: "56a1b70d64c649b1fb76b4a1e64d7c3de7a090eacc74fa5176a6d61eac45906a"
    sha256 x86_64_linux:  "3b460c6cd9918e53d25b1038733c6d80d9099a2da03385d29090d5d04b20410f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "gperf" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    ENV["PATH"] = "#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:#{ENV["PATH"]}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "-j1", "install"
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
diff --git a/src/compat.c b/src/compat.c
index 943c7f9..9b15b31 100644
--- a/src/compat.c
+++ b/src/compat.c
@@ -21,6 +21,7 @@
 #endif

 #include <libguile.h>
+#include <libguile/deprecation.h>
 #include <compat.h>
 #include <string.h>
 #include <stdio.h>
