class GuileJsonld < Formula
  desc "Implementation of the JsonLD algorithms"
  homepage "https://framagit.org/tyreunom/guile-jsonld"
  url "https://framagit.org/tyreunom/guile-jsonld/-/archive/1.0.2/guile-jsonld-1.0.2.tar.gz"
  sha256 "100d36654e6ed84b80ba62a5293dc880655dd738feaf5db16391161e89891af1"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-jsonld-1.0.2"
    sha256 cellar: :any_skip_relocation, catalina:     "8efc79677c71b90a2d36b5cd9aa3af7e1f906ed4ccd7c585d62eb32346be45ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd8c382e34c8ed9d618caf7b8f179d7e50a322ad03c64f54c87f20611671ad0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "guile"
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
