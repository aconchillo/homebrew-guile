class GuileSemver < Formula
  desc "Guile library to handle Semantic Versions and NPM-style ranges"
  homepage "https://ngyro.com/software/guile-semver.html"
  url "https://files.ngyro.com/guile-semver/guile-semver-0.1.1.tar.gz"
  sha256 "4f790919375feb204a8ea2eda92a291d9bb4de4c8eb1c6776784589a86253781"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-semver-0.1.1_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97c9ad8e236a6893bddbfe87d88469f97af5305f310c6dd3c91a1a67306fd81d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d451f2e6737989fb58831a78d1f7e76c0acfd9825bb5de7b123a2da37fc698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a041511b0c84d7c15197923301a2cfdc1a2fa30f98837d53f174c9cd910d44fd"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

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
    semver = testpath/"semver.scm"
    semver.write <<~EOS
      (use-modules (semver))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", semver
  end
end
