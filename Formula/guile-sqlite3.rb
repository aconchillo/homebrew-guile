class GuileSqlite3 < Formula
  desc "JSON module for Guile"
  homepage "https://notabug.org/guile-sqlite3/guile-sqlite3"
  url "https://notabug.org/guile-sqlite3/guile-sqlite3/archive/v0.1.1.tar.gz"
  sha256 "62a3ee73fa6ff1e5d24b589499d46038176ea1b302c29a8bcbbc6bccad1d08ef"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "sqlite3"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
    EOS
  end

  test do
    sqlite3 = testpath/"sqlite3.scm"
    sqlite3.write <<~EOS
      (use-modules (sqlite3))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"

    system "guile", sqlite3
  end
end
