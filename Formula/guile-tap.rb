class GuileTap < Formula
  desc "Test Framework that emits TAP output for GNU Guile"
  homepage "https://github.com/ft/guile-tap"
  url "https://github.com/ft/guile-tap/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "b01f64a68e78d8a5149f0d706cc3215a1374b1c226fcf200cd0d6b432d0b964c"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-tap-0.4.6_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bf6044fa8990d435f17ab127798da88414918ae4c4c93609e7ee4be7c6eb053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a43db8a4c49650309975ae2ccca51a6fa29d19fb856d00fc0edbea2e03d3f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2e93c559927a1d2ab58d2a962323701a687e94aef4718bb099fd48ad4a02ee"
  end

  depends_on "guile"

  def install
    inreplace buildpath/"bin/tap-harness", "/usr/bin", "#{HOMEBREW_PREFIX}/bin"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
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
    tap = testpath/"tap.scm"
    tap.write <<~EOS
      (use-modules (test tap))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", tap
  end
end
