class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/v0.16.3.tar.gz"
  sha256 "dcc87565910c96a44e23a4c3d0879e1bfb12008f7a7a41180e8a74469b6326ea"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ssh-0.16.2"
    sha256 cellar: :any,                 monterey:     "294452fc97890555cc33fb5cb7a39667a8ebb90548a24e8d54897256a8f9070f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d2f2832cc5582dad1ae9d923c4fa6e7ae07ae8ada6e0237ecb38020cc27ff8b"
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
