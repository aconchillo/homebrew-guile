class GuileJsonld < Formula
  desc "Implementation of the JsonLD algorithms"
  homepage "https://framagit.org/tyreunom/guile-jsonld"
  url "https://framagit.org/tyreunom/guile-jsonld/-/archive/1.0.2/guile-jsonld-1.0.2.tar.gz"
  sha256 "100d36654e6ed84b80ba62a5293dc880655dd738feaf5db16391161e89891af1"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jsonld-1.0.2_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f60dd6d25c6121fbace629c015a50f4849b4053cb82f95e3e9eb66367247fbf1"
    sha256 cellar: :any_skip_relocation, ventura:      "3cde87f2a7d4455606a3fd4ef6254cea079a95b1ab49db08b628867c7bd25148"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e630e74e3b7dc92065a6ceea9235743d5fa6bfe1035cf9c33900a5810f5212b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-gnutls"
  depends_on "guile-json"
  depends_on "guile-rdf"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./bootstrap"
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
    jsonld = testpath/"jsonld.scm"
    jsonld.write <<~EOS
      (use-modules (jsonld json))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", jsonld
  end
end
