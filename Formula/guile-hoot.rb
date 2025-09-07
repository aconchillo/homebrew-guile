class GuileHoot < Formula
  desc "Full-featured WebAssembly (WASM) toolkit in Scheme"
  homepage "https://spritely.institute/hoot/"
  url "https://files.spritely.institute/releases/guile-hoot/guile-hoot-0.6.1.tar.gz"
  sha256 "7f020e83b122b86d9089d4661de0f36fd71b19d0b24724d1cd026a0052b4ec2e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hoot-0.6.1"
    sha256 arm64_sequoia: "f293f57232e856c51dcc08c427de0801cd1d3353eae188c1a0be38253ae8798f"
    sha256 arm64_sonoma:  "afe367c23075e5aa3d78c4308964f110eab6f0e984552920df7bf71cae1149c9"
    sha256 ventura:       "374736acf04ccf0999574f3bfe661744ef5f08f2fe97ed9e69abaed66ce43454"
    sha256 x86_64_linux:  "a09362c7c786a2cbe111cb042f8efc688234deacd02345f44e0852245461983c"
  end

  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    hoot = testpath/"hoot.scm"
    hoot.write <<~EOS
      (use-modules (hoot compile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", hoot
  end
end
