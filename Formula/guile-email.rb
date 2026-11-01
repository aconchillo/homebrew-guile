class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.3.1.tar.lz"
  sha256 "1cbebc536586190914a07d0e204f2b575098fe06791ee4c31e3369162d635e08"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.3.1_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af3f98067d612187e0d3d950baded3dd1237046be72f8cca0b0ced752aa6fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade37d094c5616977e1f34accda404a9535b907b8c3820e2439f2af424a23226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d923bb34c558424a856aa1712622d0359f6c1d7205f71e23ad0be68ee1d6b3"
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
