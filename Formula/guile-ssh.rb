class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/v0.15.1.tar.gz"
  sha256 "434fdfdcd439d038c15e40290a8d3187837ad969577573baacb7b105c0c3628f"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ssh-0.15.1"
    sha256 cellar: :any,                 big_sur:      "1282a19be43556b0db5665a136b397d5919e99ec447110034f9f39300ecc653c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17992ba8accb544b0ca0afe93cc65d3c5cf848773029428e32bb8e9df42b14d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
diff --git a/libguile-ssh/Makefile.am b/libguile-ssh/Makefile.am
index ca8c6fe..c710305 100644
--- a/libguile-ssh/Makefile.am
+++ b/libguile-ssh/Makefile.am
@@ -15,7 +15,9 @@
 ## You should have received a copy of the GNU General Public License
 ## along with Guile-SSH.  If not, see <http://www.gnu.org/licenses/>.
 
-lib_LTLIBRARIES = libguile-ssh.la
+guileextensiondir = $(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions
+
+guileextension_LTLIBRARIES = libguile-ssh.la
 
 libguile_ssh_la_SOURCES = \
 	auth.c \
diff --git a/configure.ac b/configure.ac
index fc47793..c455a06 100644
--- a/configure.ac
+++ b/configure.ac
@@ -126,7 +126,7 @@ if test "x$have_srfi64" != "xyes"; then
 fi
 
 LT_INIT()
-p
+
 if test "x$guilesitedir" = "x"; then
    guilesitedir="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION"
 fi
