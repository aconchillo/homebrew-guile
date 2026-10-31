class GuileBstructs < Formula
  desc "Library for structured read/write access to binary data for Guile"
  homepage "https://dthompson.us/projects/guile-bstructs.html"
  url "https://git.dthompson.dev/guile-bstructs.git", revision: "f15aec85140b259c49d7b52933c31cad3c11acee"
  version "0.2.0"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bstructs-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2c7e1f702c7522563ccee0ff657d200d29d80606dcf8ac3982b680346384fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978ef2c1215cc12c8c9577ee28ee21c860bc4991d947a61daea762f88feb5b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e0bf56753ff38568c03c329840f44243696b28d6a3c7ccaf757c5551825a0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
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
    bstructs = testpath/"bstructs.scm"
    bstructs.write <<~EOS
      (use-modules (bstructs))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", bstructs
  end
end
