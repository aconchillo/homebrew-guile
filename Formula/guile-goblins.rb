class GuileGoblins < Formula
  desc "Distributed object programming environment"
  homepage "https://gitlab.com/spritely/guile-goblins"
  url "https://files.spritely.institute/releases/guile-goblins/guile-goblins-0.16.1.tar.gz"
  sha256 "30bb8271aaf0aa046dc6c30e341b2f7efacbcf7d0a17aced2d60328b526ece81"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-goblins-0.15.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "baf42a3c8d98a4ab3337474e649b1e50a2f07aa3ef2314f74259a5f7a57cfa68"
    sha256 cellar: :any_skip_relocation, ventura:      "0bb46220fa40e5aa3623d8ec3abab528257a3f2327cbd60fa83312890acb03cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "733ebea92e448ec72e135f7b31af4a52dc9a3584a0bec571d7c6be2880e657b7"
  end

  depends_on "texinfo" => :build
  depends_on "fibers"
  depends_on "guile"
  depends_on "guile-gcrypt"
  depends_on "guile-gnutls"
  depends_on "guile-websocket"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    goblins = testpath/"goblins.scm"
    goblins.write <<~EOS
      (use-modules (goblins))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", goblins
  end
end
