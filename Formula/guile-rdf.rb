class GuileRdf < Formula
  desc "Implementation of RDF formats and algorithms in GNU Guile"
  homepage "https://framagit.org/tyreunom/guile-rdf"
  url "https://framagit.org/tyreunom/guile-rdf/-/archive/1.0/guile-rdf-1.0.tar.gz"
  sha256 "11dcd2b970f962c484260540ca77d5bb983ae99bab81127aea5fb59c3e851de0"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-rdf-1.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "150b0e49309dc589243911b125b9c8952403205f63d21cdc389ed014a922ada9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d970bd045d3475a11c2358d29ccd1516c1ed1c74738a92db06e6bfe2ea5244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d76093176f5ac02d5258173452f66a2b95a16ff8578394d853a7808a289728"
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
