class GuileDns < Formula
  desc "Library for DNS interactions in pure Guile Scheme"
  homepage "https://git.lysator.liu.se/hugo/guile-dns"
  url "https://git.lysator.liu.se/hugo/guile-dns/-/archive/0.1/guile-dns-0.1.tar.gz"
  sha256 "3cdf6716889fb50d9e963ceec22c151290ff81ddecf089fba1f009540b3abb53"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dns-0.1_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5673de8926e594e45f72e6059b899c7000a42a4457ef8ba9f6d52711c772dd80"
    sha256 cellar: :any_skip_relocation, ventura:      "4b6fd59d64146691910ea189c502834451b73177fc8edab81bf2ca672acd2650"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d7a96d3b6a923e3ea06f90eacb0b54fd8766faf3952930a90e1bd4314659c030"
  end

  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "texinfo" => :build

  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"Makefile", "install ", "ginstall "

    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
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
    dns = testpath/"dns.scm"
    dns.write <<~EOS
      (use-modules (dns))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dns
  end
end
