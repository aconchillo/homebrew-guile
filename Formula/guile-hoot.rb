class GuileHoot < Formula
  desc "Full-featured WebAssembly (WASM) toolkit in Scheme"
  homepage "https://spritely.institute/hoot/"
  url "https://spritely.institute/files/releases/guile-hoot/guile-hoot-0.6.0.tar.gz"
  sha256 "4bf67d7b079fd7908b3b484a12ffb55f43e677522cb7bf596e7ff704f64a3856"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hoot-0.5.0"
    sha256 arm64_sonoma: "7fa528f9a29074ef71f7a9082e2bec75a02f3c493a468599beb99b98d1077165"
    sha256 ventura:      "fabb0ea87e0ebcfc6c3d3ff0a7d2d85046fb10460c1047f66d7c044a0e7a9b23"
    sha256 x86_64_linux: "7b71f75f4b673187e09a56fd185458ad8a21042795882bf98d6ffdc5e456eb08"
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
