class GuileTap < Formula
  desc "Test Framework that emits TAP output for GNU Guile"
  homepage "https://github.com/ft/guile-tap"
  url "https://github.com/ft/guile-tap/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "acc0a907c99a9ea4b9984f74fef4e530ac033e53a759ba8037c7d66f1852c4a5"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-tap-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d6ef7572020acdef12c4a0f079e35b0b185b9fb5f306777c0cf6062dae28d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b9a2cd9b1525a30ce6d3d35f66f31e2fcd6ccd3cd5109d8e2b9e6e899f6ac38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cea1b0e9758166a2fad1fc0b323a3fc67a0f752f7f7a86511282698ac680966"
  end

  depends_on "guile"

  def install
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
