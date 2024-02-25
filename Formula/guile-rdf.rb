class GuileRdf < Formula
  desc "Implementation of RDF formats and algorithms in GNU Guile"
  homepage "https://framagit.org/tyreunom/guile-rdf"
  url "https://framagit.org/tyreunom/guile-rdf/-/archive/1.0/guile-rdf-1.0.tar.gz"
  sha256 "11dcd2b970f962c484260540ca77d5bb983ae99bab81127aea5fb59c3e851de0"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-rdf-1.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "671f82c550c4b197683e043d219d0dab2bf122404178eaebcaff1bfdda9f1761"
    sha256 cellar: :any_skip_relocation, ventura:      "be90669eb0eacdf21255d235233468a2a739f8a570b569e852238b5364326cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "acb9ff1c31014c3bb9a2bf788a92d7a5172a8f8e55ebf5417cc7fdbc9b2f792a"
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
