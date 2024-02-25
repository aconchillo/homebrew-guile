class GuileRdf < Formula
  desc "Implementation of RDF formats and algorithms in GNU Guile"
  homepage "https://framagit.org/tyreunom/guile-rdf"
  url "https://framagit.org/tyreunom/guile-rdf/-/archive/1.0/guile-rdf-1.0.tar.gz"
  sha256 "11dcd2b970f962c484260540ca77d5bb983ae99bab81127aea5fb59c3e851de0"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-rdf-1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "761d617928e64b44ebef23c6f99c2ff6569862f387b1def94afd203380c7e83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "455394c7df2a20bf3ea2fbb0d7ebd9f05cc51603eb7d121237dec20921849358"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    rdf = testpath/"rdf.scm"
    rdf.write <<~EOS
      (use-modules (rdf rdf))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", rdf
  end
end
