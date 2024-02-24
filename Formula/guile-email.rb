class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.3.1.tar.lz"
  sha256 "1cbebc536586190914a07d0e204f2b575098fe06791ee4c31e3369162d635e08"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.3.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0071fbe545a4897c0923bff11faccd01ccc693776c64839b33416bb2d4fa0adf"
    sha256 cellar: :any_skip_relocation, ventura:      "42e7cf961812b5b8dea2d0b4352fb3c095f73bf5affef3e38286647e79460eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "04770bfade2d82078d73ca770d7e77fc4ca667292d16858dc4ab4e3086ac4f1c"
  end

  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"Makefile", "install ", "ginstall "

    system "make"
    system "make", "install", "prefix=#{prefix}"
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
