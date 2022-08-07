class GuileJson < Formula
  desc "JSON module for Guile"
  homepage "https://github.com/aconchillo/guile-json"
  url "https://download.savannah.gnu.org/releases/guile-json/guile-json-4.7.2.tar.gz"
  sha256 "942ab7ec5b40856799c0ca9fb81921af17fc4360aebef1cc8cb1f6ad9220d519"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-4.7.2"
    sha256 cellar: :any_skip_relocation, monterey:     "105bb047b567ea514b7d85fe4a68cde8ba994ebb4b2ea1af708c46a5e989c054"
    sha256 cellar: :any_skip_relocation, big_sur:      "36fb96ea08bb5a69db9d2cb749363cd735e8f6e964ec8238806bcf754afb751d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6836af680543d8d6421ffb3d87d28d5c989ba2cd6a923bdc0ba05a1df85ee28a"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

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
    json = testpath/"json.scm"
    json.write <<~EOS
      (use-modules (json))
      (json-string->scm "1")
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", json
  end
end
