class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9be26290cdd65ffe812d1e69d4bb87a2d41d2ee72ff8db65dee817fc315f153c"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ssh-1.0.0"
    sha256 cellar: :any, arm64_tahoe:   "4d55cfa9d5bc0fdb205b9451c2397174fc5a6d0e61d74e3e2df302fb133b1760"
    sha256 cellar: :any, arm64_sequoia: "f08ab310969fd4b4169f907600e1c8fcc35a45f0a454a0d336cae72c54ad3cbf"
    sha256 cellar: :any, x86_64_linux:  "9bdf2667449925ea2bc8b8ce51bcaa9d3c69e5efffccdc7b6a24278352881279"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "libssh"

  on_macos do
    depends_on "bdw-gc"
  end

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
