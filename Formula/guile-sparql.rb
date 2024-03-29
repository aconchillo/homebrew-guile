class GuileSparql < Formula
  desc "SPARQL module for Guile"
  homepage "https://github.com/roelj/guile-sparql"
  url "https://github.com/roelj/guile-sparql/releases/download/0.0.8/guile-sparql-0.0.8.tar.gz"
  sha256 "96daf40b48bef9a69e8fe05a07b7d97dd05f13b3b717835a06f5bae4c449c4c9"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sparql-0.0.8_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2d3ecb215b79eec355fb1da480a68fdd54d2f94a5bed7ade1765459f98ef36a4"
    sha256 cellar: :any_skip_relocation, ventura:      "d268818634d9aa2c38b16df9df2d798e271e134270fd81984d89329f6f2f46b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "881418fae247764cacd190b688447f39b9d17e484dc70be024b37cfea50315d0"
  end

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
