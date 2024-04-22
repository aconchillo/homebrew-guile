class Nyacc < Formula
  desc "Guile modules for generating parsers and lexical analyzers"
  homepage "https://www.nongnu.org/nyacc/"
  url "https://download.savannah.gnu.org/releases/nyacc/nyacc-1.09.4.tar.gz"
  sha256 "ee6546d4e918fc6b59b716abbe42c14a0cf454f5a82bf644671cced5b9d70141"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/nyacc-1.09.3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "088647db2ddccf619478f8766fb01de8b3099ee352aed6decd71350ada2cbfc6"
    sha256 cellar: :any_skip_relocation, ventura:      "7c151c9a2d7c91cee1be1db2eb28c9f4235215b89139f52174fccb2711ea1434"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72a152042e1c1b0cbfc068fbe1ec42f659c832d87e2ad23351eb5fadf91b5f27"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-bytestructures"

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
    nyacc = testpath/"nyacc.scm"
    nyacc.write <<~EOS
      (use-modules (nyacc parse))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", nyacc
  end
end
