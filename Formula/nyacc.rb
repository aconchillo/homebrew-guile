class Nyacc < Formula
  desc "Guile modules for generating parsers and lexical analyzers"
  homepage "https://www.nongnu.org/nyacc/"
  url "https://download.savannah.gnu.org/releases/nyacc/nyacc-2.01.4.tar.gz"
  sha256 "32b1806a2d2b80fad100e3d92e2800b2e6ad961a5958d71bfad17e278dc8791b"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/nyacc-2.01.4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "7637d0b7076983fa3f9868b8eec4103ff2693ba38d3f47287cc356c7e3019589"
    sha256 cellar: :any_skip_relocation, ventura:      "3f118b2fce8c4f7d148e50aaa181c4f6e0ea3000c3aa96f4fdcff536663975a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "66170a723c06749552bec7234f226b863820449b2f7a0943a214ee47fdb79920"
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
