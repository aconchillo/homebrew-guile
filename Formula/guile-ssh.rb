class GuileSsh < Formula
  desc "SSH library for programs written in Guile"
  homepage "https://github.com/artyom-poptsov/guile-ssh"
  url "https://github.com/artyom-poptsov/guile-ssh/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ce6670a2114d3269c2f79153adc8d6bd251d7c649fee0f02f5e893104a1b38bc"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ssh-0.17.0_1"
    sha256 cellar: :any, arm64_tahoe:   "9558ba2a5ed0b40fbec07247681f3b2827f9ac8fd43b1667d920552bb0bad884"
    sha256 cellar: :any, arm64_sequoia: "515ea26ccfcab075d88f3537457c646e148c02514eb7b00fb1787890326d8732"
    sha256 cellar: :any, x86_64_linux:  "2fb5843fe7990e31b8a928f6a0d3a813c50592966017de219703a12bed32ff78"
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
    # Newer libssh headers include <stdbool.h>, so `bool` can't be a variable name.
    inreplace "libguile-ssh/session-func.c" do |s|
      s.gsub! "int32_t bool;", "int32_t bool_value;"
      s.gsub! "bool = scm_to_bool (value);", "bool_value = scm_to_bool (value);"
      s.gsub! "&bool);", "&bool_value);"
    end

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
