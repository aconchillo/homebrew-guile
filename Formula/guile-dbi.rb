class GuileDbi < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/guile-dbi-2.1.7.tar.gz"
  sha256 "e337c242891221e2bf6da5433f4d5144c40b37da400a3a011c8ac07390516df4"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbi-2.1.7"
    sha256 cellar: :any,                 catalina:     "8c36fc35fe5b3780761cf8b10ddac5becce490355c3ec4998a473daa4fda3ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "150e72d54415e9366e597275b521473611af95d32ee26a60ecd18be654e4c76c"
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
