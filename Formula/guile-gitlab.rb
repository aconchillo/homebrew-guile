class GuileGitlab < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-gitlab"
  url "https://github.com/artyom-poptsov/guile-gitlab/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b499661fad29efee997dae01d2cd614da2d78aa094892e6228d41f7cdcf4739c"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "guile"
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
    gitlab = testpath/"gitlab.scm"
    gitlab.write <<~EOS
      (use-modules (gitlab))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gitlab
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 401a51a..97ddb3c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,7 +45,7 @@ AC_ARG_WITH([guilesitedir],
              esac],
              [guilesitedir=""])

-GUILE_PKG([2.2 2.0])
+GUILE_PKG([3.0 2.2 2.0])
 GUILE_PROGS
 GUILE_SITE_DIR

diff --git a/modules/gitlab/cli/common.scm b/modules/gitlab/cli/common.scm
index 8da5752..7ef166d 100644
--- a/modules/gitlab/cli/common.scm
+++ b/modules/gitlab/cli/common.scm
@@ -1,4 +1,5 @@
 (define-module (gitlab cli common)
+  #:use-module (ice-9 format)
   #:use-module (ice-9 pretty-print)
   #:export (print
             print-many
