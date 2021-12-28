class GuileJson < Formula
  desc "JSON module for Guile"
  homepage "https://github.com/aconchillo/guile-json"
  url "https://download.savannah.gnu.org/releases/guile-json/guile-json-4.6.0.tar.gz"
  sha256 "cecd1d74082eaa286b87845d57f0460b2d00b7539d37b5fddcc2fc3b446ba48f"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-json-4.5.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "68ab088f6dd30518dd58be2429b85c4056c5f48355127bfec03650e1d1a04e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "536779d0f6cf4618a7b8dce7645cae7920102796de72d095c2ee897bbb9f60bc"
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
