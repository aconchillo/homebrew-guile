class GuileSemver < Formula
  desc "Guile library to handle Semantic Versions and NPM-style ranges"
  homepage "https://ngyro.com/software/guile-semver.html"
  url "https://files.ngyro.com/guile-semver/guile-semver-0.1.1.tar.gz"
  sha256 "4f790919375feb204a8ea2eda92a291d9bb4de4c8eb1c6776784589a86253781"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-semver-0.1.1_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "fb51168867afee86933a64e52334b7cbd478316d653d9e3b15a0d564a0b6fbf3"
    sha256 cellar: :any_skip_relocation, ventura:      "a8d1ffdb18f733162b425302a0d3c7584f66e84bbe69a71cde2defc303bf6258"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be64d2ca459ff5566ea76a815bf5f298bf50d0501db84f5913418fc0f26d0750"
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
