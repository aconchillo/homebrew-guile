class GuileJson < Formula
  desc "JSON module for Guile"
  homepage "https://github.com/aconchillo/guile-json"
  url "https://download.savannah.gnu.org/releases/guile-json/guile-json-4.6.0.tar.gz"
  sha256 "cecd1d74082eaa286b87845d57f0460b2d00b7539d37b5fddcc2fc3b446ba48f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-4.6.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "9b978649a377391a8691abe47ee75b9cc9e217b5ad4c7fce93006bc49755a0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5ae723de1b115647bcb85391404ad223ce2fdc70f597d69093e294b5bb3f80a"
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
