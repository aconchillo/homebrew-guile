class GuileDbi < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/guile-dbi-2.1.7.tar.gz"
  sha256 "e337c242891221e2bf6da5433f4d5144c40b37da400a3a011c8ac07390516df4"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbi-2.1.7"
    cellar :any
    sha256 "ac8942d8044e98b7c87238ed379c2e38554e71c647d5a75e07dd300f35d3a287" => :catalina
    sha256 "3e30fad491e7f12d2b8d74f2f8a95b7e94a36b2520906a12aaff9b93d5190ced" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chdir "guile-dbi" do
      system "autoreconf", "-vif"
      system "./configure", "--prefix=#{prefix}",
             "--with-guile-site-dir=#{share}/guile/site/3.0"
      system "make", "install"
    end
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
    dbi = testpath/"dbi.scm"
    dbi.write <<~EOS
      (use-modules (dbi dbi))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dbi
  end
end
