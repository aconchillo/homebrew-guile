class GuileQuickcheck < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://ngyro.com/software/guile-quickcheck.html"
  url "https://files.ngyro.com/guile-quickcheck/guile-quickcheck-0.1.0.tar.gz"
  sha256 "cb99ac5be99b43b61eb9c452d953543e890e2a83fc83acac289d94316888bc0e"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-quickcheck-0.1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "41d7c4555ada9e82be0eb0259b4ce6ae1b071e0ce45e1760a099dc749aee005d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f612a5d1e47e8f8dfccc9e66d31193a16d9304a66b56f4145525947a781f72b4"
  end

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
    quickcheck = testpath/"quickcheck.scm"
    quickcheck.write <<~EOS
      (use-modules (quickcheck))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", quickcheck
  end
end
