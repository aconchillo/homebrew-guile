class GuileDbdMysql < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/refs/tags/guile-dbi-2.1.8.tar.gz"
  sha256 "c6a84a63b57ae23c259c203063f4226ac566161e0261f4e1d2f2f963ad06e4e7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbd-mysql-2.1.8"
    sha256 x86_64_linux: "40a40f6d32d6cd4d8d2a4d8bf81e196d21ee5f489382fad3ede0fda2229d550f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "guile"
  depends_on "guile-dbi"
  depends_on "mariadb"
  depends_on "openssl@1.1"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chdir "guile-dbd-mysql" do
      system "autoreconf", "-vif"
      system "./configure", "--prefix=#{prefix}"
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
--- a/guile-dbd-mysql/configure.ac	2023-06-08 08:38:53
+++ b/guile-dbd-mysql/configure.ac	2023-06-08 08:40:53
@@ -52,10 +52,6 @@
 AC_FUNC_MALLOC
 AC_HEADER_STDC

-# Checks for libs
-AC_CHECK_LIB(mariadbclient,mysql_init,,
-        AC_MSG_ERROR([*** Can't find libmysql]))
-
 CFLAGS=`guile-config compile`
 LIBS=`guile-config link`

@@ -63,8 +59,12 @@
 MYSQL_LIBS=`mariadb_config --libs_r`

 CFLAGS="${CFLAGS} ${MYSQL_CFLAGS}"
-LIBS="${LIBS} ${MYSQL_LIBS}"
+LIBS="${LIBS} ${MYSQL_LIBS} -lcrypto -lssl -lz"

+# Checks for libs
+AC_CHECK_LIB(mariadbclient,mysql_init,,
+        AC_MSG_ERROR([*** Can't find libmysql]), [${LIBS}])
+
 . $srcdir/DBD-VERSION
 AC_SUBST(DBD_MAJOR_VERSION)
 AC_SUBST(DBD_MINOR_VERSION)
--- a/guile-dbd-mysql/src/guile-dbd-mysql.c	2023-06-08 13:22:48
+++ b/guile-dbd-mysql/src/guile-dbd-mysql.c	2023-06-08 13:23:32
@@ -23,8 +23,8 @@

 #include <guile-dbi/guile-dbi.h>
 #include <libguile.h>
-#include <mariadb/mysql.h>
-#include <mariadb/errmsg.h>
+#include <mysql/mysql.h>
+#include <mysql/errmsg.h>
 #include <string.h>
 #include <errno.h>
 #include <stdlib.h>
