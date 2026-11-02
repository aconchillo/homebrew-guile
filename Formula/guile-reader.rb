class GuileReader < Formula
  desc "Simple framework for building readers for GNU Guile"
  homepage "https://www.nongnu.org/guile-reader/"
  url "https://download.savannah.nongnu.org/releases/guile-reader/guile-reader-0.6.4.tar.gz"
  sha256 "6b220033ac2e71b7bef41a43f354c22b9986a675a4d12ed31cf744143a99135b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-reader-0.6.4"
    sha256 arm64_tahoe:   "8d522f148d91fee850e4515dda7729855d3f6762faaa9955df8667be518f5cfc"
    sha256 arm64_sequoia: "bd40e2add59a5c98fe0e8e2fc78132a013091c690933b1e75aa8ebc6f4f2837c"
    sha256 x86_64_linux:  "4461df1e68310a1852753bcf1f8db63e8066c78e7ea209647c4ec51b2c9bc549"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "gperf" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    ENV["PATH"] = "#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:#{ENV["PATH"]}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "-j1", "install"
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
    reader = testpath/"reader.scm"
    reader.write <<~EOS
      (use-modules (system reader))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", reader
  end
end
