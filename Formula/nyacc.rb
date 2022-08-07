class Nyacc < Formula
  desc "Guile modules for generating parsers and lexical analyzers"
  homepage "https://www.nongnu.org/nyacc/"
  url "https://download.savannah.gnu.org/releases/nyacc/nyacc-1.07.0.tar.gz"
  sha256 "57c9ded03a4cde25878b667c29131e5fd0e20a0ea715d53afa0499b90c340b07"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/nyacc-1.06.0"
    sha256 cellar: :any_skip_relocation, catalina:     "e7e70f8134c10a2844dd10ddbc63f66b2b677f5e80a99429786297e54e2f357f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d972e43a290a7342b28bca2e22bbe44c1fd3127cc4328af9e9ca889f8ed2bc9"
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
