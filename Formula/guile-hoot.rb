class GuileHoot < Formula
  desc "Full-featured WebAssembly (WASM) toolkit in Scheme"
  homepage "https://spritely.institute/hoot/"
  url "https://spritely.institute/files/releases/guile-hoot/guile-hoot-0.3.0.tar.gz"
  sha256 "c12aa415c17d3d529a59065cefd275917596fb518f03d96fe38fa06efbb9ecfd"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hoot-0.3.0"
    sha256 arm64_sonoma: "cc98be1c2743f558af42011add8ad7d9aac3d35b4b54943351390b04907ee5e9"
    sha256 ventura:      "42a83279c229cba6036272ec07e4b21f5357f4f47b26acbc9683b53879ea9440"
    sha256 x86_64_linux: "b906c39906ceefcd47fefa78a499150a485b7cbc86870a7c2ae85081ee276e4f"
  end

  depends_on "texinfo" => :build
  depends_on "guile-next"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use `guile-hoot` you need to unlink `guile` and then link `guile-next`:
        brew unlink guile
        brew link guile-next

      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
    EOS
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
