class GuileFScm < Formula
  desc "Library for working with files and directories"
  homepage "https://git.sr.ht/~brown121407/f.scm"
  url "https://git.sr.ht/~brown121407/f.scm/archive/0.2.0.tar.gz"
  sha256 "c4c2d4c395b7a54344c7fce3b74a7158b9cf812c4ae1a108c62761c34b503f3e"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-f-scm-0.2.0_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb959441808373c50ab77a593748325ef7be7d07cce013dfa95641f11dfdf01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2dffc28cd1c48f7124950ef51d1b23c68f17d0d03164e8194789e46320761bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbae3d632fb8b88a1a93719d16beb0d70b4731af8a0976aa29018d643390802"
  end

  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    load_path = Pathname.new "#{share}/guile/site/3.0"
    load_path.mkpath

    cp "#{buildpath}/f.scm", load_path
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
    f = testpath/"f.scm"
    f.write <<~EOS
      (use-modules (f))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", f
  end
end
