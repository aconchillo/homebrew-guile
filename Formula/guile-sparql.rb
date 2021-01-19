class GuileSparql < Formula
  desc "SPARQL module for Guile"
  homepage "https://github.com/roelj/guile-sparql"
  url "https://github.com/roelj/guile-sparql/releases/download/0.0.8/guile-sparql-0.0.8.tar.gz"
  sha256 "96daf40b48bef9a69e8fe05a07b7d97dd05f13b3b717835a06f5bae4c449c4c9"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sparql-0.0.8"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2675eb8a8079b7c2394aa338c7f5b08836a7c9cdaf620e66578de1fa50b1f326" => :catalina
    sha256 "f00f1e36028c0716e19e7271c03cdd88f659ffa7cebb3f1a7e5c947a5d51e47e" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    sparql = testpath/"sparql.scm"
    sparql.write <<~EOS
      (use-modules (sparql driver) (sparql lang))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", sparql
  end
end

__END__
diff --git a/env.in b/env.in
index 2884c30..a7edb73 100644
--- a/env.in
+++ b/env.in
@@ -14,11 +14,11 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.

-GUILE_LOAD_PATH=@abs_top_srcdir@/web:$GUILE_LOAD_PATH
+GUILE_LOAD_PATH=@abs_top_srcdir@:$GUILE_LOAD_PATH
 if test "@abs_top_srcdir@" != "@abs_top_builddir@"; then
-    GUILE_LOAD_PATH=@abs_top_builddir@/web:$GUILE_LOAD_PATH
+    GUILE_LOAD_PATH=@abs_top_builddir@:$GUILE_LOAD_PATH
 fi
-GUILE_LOAD_COMPILED_PATH=@abs_top_builddir@/web:$GUILE_LOAD_PATH
+GUILE_LOAD_COMPILED_PATH=@abs_top_builddir@:$GUILE_LOAD_PATH
 PATH=@abs_top_builddir@/bin:$PATH

 export GUILE_LOAD_PATH
