class Nyacc < Formula
  desc "Guile modules for generating parsers and lexical analyzers"
  homepage "https://www.nongnu.org/nyacc/"
  url "https://download.savannah.gnu.org/releases/nyacc/nyacc-4.0.0.tar.gz"
  sha256 "2aef45e5641c2ccd2a7a914da8668fb4e91ccebef12b13497528fcd7b0c76a05"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/nyacc-4.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac440a05552a2de2cbecd28f99d48439018b8bed4845180478a7cf4bb5684957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17a7d7a328d788bb45d8d807fef27ecd43b1b9a63f926e90ddc0a31368c7a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c831bc48ccef0bdfcccd641e9fedfff08dc3bfd55966c6030e8ee43d0deb0b0a"
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
