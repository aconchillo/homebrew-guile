class GuileHoot < Formula
  desc "Full-featured WebAssembly (WASM) toolkit in Scheme"
  homepage "https://spritely.institute/hoot/"
  url "https://files.spritely.institute/releases/guile-hoot/guile-hoot-0.6.1.tar.gz"
  sha256 "7f020e83b122b86d9089d4661de0f36fd71b19d0b24724d1cd026a0052b4ec2e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hoot-0.6.0"
    sha256 arm64_sonoma: "77baf0bb36cee835b7caec3f76d6a1fc4044441bed23d6a95293224e9ac747b4"
    sha256 ventura:      "b21a53d79e6b7ac35759cdd1b8db00c68914f2512aced0a949e6b078a944f80d"
    sha256 x86_64_linux: "ce2305c62f3727d5947257f903c06fd06b4d4f90aa0bc1588d41179353f20c52"
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
