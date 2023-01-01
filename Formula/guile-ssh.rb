class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/v0.16.1.tar.gz"
  sha256 "53333c82bcf810ef628644e16343f6f996eff0f7460a45681b17ee5a9229912d"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ssh-0.16.0"
    sha256 cellar: :any,                 monterey:     "67d0ba3deea216488d83aad4ae139deb8b4e39a459cf35b1a2e068d528858b39"
    sha256 cellar: :any,                 big_sur:      "c2071d43ab71b7c242f0a83a74ba9a93852c803e5054ea0ac291ba5c30caf180"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3511636b8b866e4ca6f32686de9ed37cf7d0d073d995a1b2777e9e356abfbcf9"
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
