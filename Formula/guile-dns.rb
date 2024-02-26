class GuileDns < Formula
  desc "Library for DNS interactions in pure Guile Scheme"
  homepage "https://git.lysator.liu.se/hugo/guile-dns"
  url "https://git.lysator.liu.se/hugo/guile-dns/-/archive/0.1/guile-dns-0.1.tar.gz"
  sha256 "3cdf6716889fb50d9e963ceec22c151290ff81ddecf089fba1f009540b3abb53"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dns-0.1"
    sha256 cellar: :any_skip_relocation, monterey:     "39c11e34c4310292b09e9ac725e05a8b0706b7e300bd5eedf35c2092aefa6b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4de778d88677ae39c49613de359ebf32a954ea86ac5dad05201f43537c49856"
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
