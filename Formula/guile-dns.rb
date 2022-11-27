class GuileDns < Formula
  desc "Library for DNS interactions in pure Guile Scheme"
  homepage "https://git.lysator.liu.se/hugo/guile-dns"
  url "https://git.lysator.liu.se/hugo/guile-dns/-/archive/0.1/guile-dns-0.1.tar.gz"
  sha256 "3cdf6716889fb50d9e963ceec22c151290ff81ddecf089fba1f009540b3abb53"

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
