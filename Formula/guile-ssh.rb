class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/v0.12.0.tar.gz"
  sha256 "d5b610fa0259187a824dfd26b11a415c1ca7b107912feea8b1a9e7c0fcfbe59c"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libssh"

  patch :DATA

  def install
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
    ssh = testpath/"ssh.scm"
    ssh.write <<~EOS
      (use-modules (ssh session))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ssh
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index da11f30..3a4fba4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -35,6 +35,7 @@ AM_INIT_AUTOMAKE([color-tests])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])], [AC_SUBST([AM_DEFAULT_VERBOSITY],1)])

 AC_PROG_CC
+LT_INIT([disable-static])

 if test "x$GCC" = "xyes"; then
   # Use compiler warnings.
diff --git a/modules/ssh/Makefile.am b/modules/ssh/Makefile.am
index dbc2cf9..c6d5bf5 100644
--- a/modules/ssh/Makefile.am
+++ b/modules/ssh/Makefile.am
@@ -66,8 +66,8 @@ endif
 guilec_env  = 									\
 	GUILE_AUTO_COMPILE=0 							\
 	$(CROSS_COMPILING_VARIABLE)                                      	\
-	LD_LIBRARY_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${LD_LIBRARY_PATH}"	\
-	GUILE_LOAD_PATH="$(abs_top_srcdir)/modules"					\
+	GUILE_SYSTEM_EXTENSIONS_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${GUILE_SYSTEM_EXTENSIONS_PATH}"	\
+	GUILE_LOAD_PATH="$(abs_top_srcdir)/modules"				\
 	GUILE_LOAD_COMPILED_PATH="$(builddir)/ssh:$$GUILE_LOAD_COMPILED_PATH"

 .scm.go:
diff --git a/modules/ssh/dist/Makefile.am b/modules/ssh/dist/Makefile.am
index 19050a8..480372d 100644
--- a/modules/ssh/dist/Makefile.am
+++ b/modules/ssh/dist/Makefile.am
@@ -61,7 +61,7 @@ endif
 guilec_env  = 									\
 	GUILE_AUTO_COMPILE=0 							\
 	$(CROSS_COMPILING_VARIABLE)                                      	\
-	LD_LIBRARY_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${LD_LIBRARY_PATH}"	\
+	GUILE_SYSTEM_EXTENSIONS_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${GUILE_SYSTEM_EXTENSIONS_PATH}"	\
 	GUILE_LOAD_PATH="$(abs_top_srcdir)/modules"				\
 	GUILE_LOAD_COMPILED_PATH="$(builddir)/ssh:$$GUILE_LOAD_COMPILED_PATH"

diff --git a/tests/Makefile.am b/tests/Makefile.am
index e31119c..d1af611 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -1,9 +1,9 @@
-## Config file for GNU Automake.
+## Config file for GNU Automake.
 ##
 ## Copyright (C) 2014, 2015, 2016 Artyom V. Poptsov <poptsov.artyom@gmail.com>
 ##
 ## This file is part of Guile-SSH.
-##
+##
 ## Guile-SSH is free software: you can redistribute it and/or
 ## modify it under the terms of the GNU General Public License as
 ## published by the Free Software Foundation, either version 3 of the
@@ -87,8 +87,8 @@ guilec_opts = 					\
 # TODO: Move environment setup to a separate file.
 guilec_env  = 									\
 	GUILE_AUTO_COMPILE=0 							\
-	LD_LIBRARY_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${LD_LIBRARY_PATH}"	\
-	GUILE_LOAD_PATH="$(abs_top_srcdir)/modules"					\
+	GUILE_SYSTEM_EXTENSIONS_PATH="$(abs_top_builddir)/libguile-ssh/.libs/:${GUILE_SYSTEM_EXTENSIONS_PATH}"	\
+	GUILE_LOAD_PATH="$(abs_top_srcdir)/modules"				\
 	GUILE_LOAD_COMPILED_PATH="$(builddir)/ssh:$$GUILE_LOAD_COMPILED_PATH"

 .scm.go:
