class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.2.2.tar.lz"
  sha256 "b38c6ab2f2534c15b29c7a23d5ffbc4f5ff8348af1d0c90af696bafd1cc888e5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.2.2"
    sha256 cellar: :any_skip_relocation, catalina:     "3a3cd8d22719c6b80ad5713db263960063bc5ba357d4a9aebbbabd89c907e2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d0035366ac6662442037c3eb550f21d0b125fc92f34060b3bfd8101a282e0089"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
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
    email = testpath/"email.scm"
    email.write <<~EOS
      (use-modules (email email))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", email
  end
end
