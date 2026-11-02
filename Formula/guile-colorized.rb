class GuileColorized < Formula
  desc "Colorized REPL for GNU Guile"
  homepage "https://gitlab.com/NalaGinrut/guile-colorized"
  url "https://gitlab.com/NalaGinrut/guile-colorized/-/archive/v0.2/guile-colorized-v0.2.tar.gz"
  sha256 "5d7aeeebf049114339dcabaa70c3f83b5b68b836cc0057c3a3c2c4b56e00007a"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-colorized-0.1_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f11e7f4644000e84ac8695875104ca716bc135a1be0d01b3e56d73ba5d5e54d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336d4cf1576137570469e0ecc360657aa6786aee97d6bf33d8418dba41d68a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98847ae595296fe8e7e91bf929db8ca575432834e44073167985ca4ed0e81832"
  end

  depends_on "guile"

  def install
    inreplace buildpath/"Makefile", "$(TARGET)", "$(DESTDIR)/share/guile/site/3.0/ice-9/"

    mkdir "#{share}/guile/site/3.0/ice-9/"

    system "make", "DESTDIR=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"

      To enable colors on your Guile REPL add the following to your ~/.guile:
        (use-modules (ice-9 colorized))
        (activate-colorized)
    EOS
  end

  test do
    colorized = testpath/"colorized.scm"
    colorized.write <<~EOS
      (use-modules (ice-9 colorized))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", colorized
  end
end
