class GuileHoot < Formula
  desc "Full-featured WebAssembly (WASM) toolkit in Scheme"
  homepage "https://spritely.institute/hoot/"
  url "https://files.spritely.institute/releases/guile-hoot/guile-hoot-0.10.0.tar.gz"
  sha256 "34aff22640b33f0a8af7a1d5fe89426ad212e0894ee794a84f8d3701af01a070"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hoot-0.10.0"
    sha256 arm64_tahoe:   "7a002ccf8e2d68312ccfb4158478797ee22de980e2b790b7450f61947583eeff"
    sha256 arm64_sequoia: "91c3f5922c1c4ce64c2d2a62cd11c022ffbd0e6cf6cbdeb877e4941c4acc52f9"
    sha256 x86_64_linux:  "930ae08c86708173afc59bfe0e12c640e79ba652d86e70f5204e38822e61afab"
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
