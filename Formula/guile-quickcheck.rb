class GuileQuickcheck < Formula
  desc "Guile 3.0/2.x bindings to the GNU Libgcrypt cryptography library"
  homepage "https://ngyro.com/software/guile-quickcheck.html"
  url "https://files.ngyro.com/guile-quickcheck/guile-quickcheck-0.1.0.tar.gz"
  sha256 "cb99ac5be99b43b61eb9c452d953543e890e2a83fc83acac289d94316888bc0e"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-quickcheck-0.1.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db6e0c720ada834540028c7ab9a28aa8ae2a689009727fb1c18c454b332e7fa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0543be948bb45e249e2aae429d588a54f12afc64e2ebefd51e47272d8913ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afc4f3d268623020787a89973e5d56115b33ff408ea8d4754b758f87220c438"
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
