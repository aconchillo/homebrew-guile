class GuileDbdMysql < Formula
  desc "Guile scheme interface to SQL databases"
  homepage "https://github.com/opencog/guile-dbi"
  url "https://github.com/opencog/guile-dbi/archive/refs/tags/guile-dbi-3.2.0.tar.gz"
  sha256 "3e7729cf389878d069f7c5884dba95be0dc4a0e32116d830bdebdaf9ebbd7291"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "guile"
  depends_on "guile-dbi"
  depends_on "mariadb"

  on_macos do
    depends_on "bdw-gc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    chdir "guile-dbd-mysql" do
      # Homebrew's mariadb installs its headers in include/mysql, which
      # libmariadb.pc already adds to the include path.
      inreplace "src/guile-dbd-mysql.c", "<mariadb/", "<"
      # automake's default GNU strictness requires a NEWS file.
      touch "NEWS"
      system "autoreconf", "-vif"
      system "./configure", "--prefix=#{prefix}"
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
