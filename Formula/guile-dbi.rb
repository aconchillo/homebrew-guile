class GuileDbi < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/refs/tags/guile-dbi-2.1.8.tar.gz"
  sha256 "c6a84a63b57ae23c259c203063f4226ac566161e0261f4e1d2f2f963ad06e4e7"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dbi-2.1.8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f18cbb0ce8634b335353110e20636547c3ce3d35f83c4bc99a254d4551d78be"
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
