class GuileZstd < Formula
  desc "GNU Guile bindings to the zstd compression library"
  homepage "https://notabug.org/guile-zstd/guile-zstd"
  url "https://notabug.org/guile-zstd/guile-zstd/archive/v0.1.1.tar.gz"
  sha256 "6e57ef524f20cab79ca5fd62366c5435f71cf652f582fc1e7d62585e90d499c5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-zstd-0.1.1"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d923cf794353e2ba962d3d10e5e2f11d945f824d31975907fb8683525840a080" => :catalina
    sha256 "b895dbf3155f7a6f0046fad64cc6132cbe804f8efe8fc1dc7bcbfaee3690239d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "zstd"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    zstd = testpath/"zstd.scm"
    zstd.write <<~EOS
      (use-modules (zstd))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", zstd
  end
end

__END__
diff --git a/zstd/config.scm.in b/zstd/config.scm.in
index 150dfb9..07b5c41 100644
--- a/zstd/config.scm.in
+++ b/zstd/config.scm.in
@@ -20,7 +20,4 @@
   #:export (%zstd-library-file-name))

 (define %zstd-library-file-name
-  ;; 'dynamic-link' in Guile >= 3.0.2 first looks up file names literally
-  ;; (hence ".so.1"), which is not the case with older versions of Guile.
-  (cond-expand ((not guile-3) "@ZSTD_LIBDIR@/libzstd")
-               (else          "@ZSTD_LIBDIR@/libzstd.so.1")))
+  "@ZSTD_LIBDIR@/libzstd")
