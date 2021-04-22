class GuileMastodon < Formula
  desc "GNU Guile module implementing Mastodon REST API protocol"
  homepage "https://framagit.org/prouby/guile-mastodon"
  url "https://framagit.org/prouby/guile-mastodon/-/archive/v0.0.2/guile-mastodon-v0.0.2.tar.gz"
  sha256 "9b65a202ea9e09f1f8c9c0efd3130545c28a533c12ece1f2def68b8c1fbae4c7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-mastodon-0.0.2"
    sha256 cellar: :any_skip_relocation, catalina:     "2e2b3eeff8a76bfe76e86df4f1f6f5eec5cd4e0fae318b3b12548ff699d76bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8203245b05ca176b12a2369809886cdc1fee37cfc76e96323933b696a456e256"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "guile-json"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    inreplace buildpath/"configure.ac", "guile-2.2", "guile-3.0"
    inreplace buildpath/"configure.ac", "2.2", "3.0"
    inreplace buildpath/"Makefile.am", "include doc/local.mk", ""

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
    mastodon = testpath/"mastodon.scm"
    mastodon.write <<~EOS
      (use-modules (mastodon))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", mastodon
  end
end
