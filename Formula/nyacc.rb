class Nyacc < Formula
  desc "Guile modules for generating parsers and lexical analyzers"
  homepage "https://www.nongnu.org/nyacc/"
  url "https://download.savannah.gnu.org/releases/nyacc/nyacc-1.04.1.tar.gz"
  sha256 "6246772ab5859556ef1397d2b7182eb9ad2b6a078fb423a832c67bff889a6ff1"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/nyacc-1.04.1"
    sha256 cellar: :any_skip_relocation, catalina:     "dd3174ec4f45984085a53908533f2ae1491dee8838b53f8bc1b693e16f53f392"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d1a3ea3327cb26f50b7875e16e8ef5bdb81ce6fe2f839643fa4f0ff01ad07f6"
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
