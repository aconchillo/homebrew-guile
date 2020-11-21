class GuileSqlite3 < Formula
  desc "Guile bindings to SQLite3"
  homepage "https://notabug.org/guile-sqlite3/guile-sqlite3"
  url "https://notabug.org/guile-sqlite3/guile-sqlite3/archive/v0.1.2.tar.gz"
  sha256 "dc88fbcd30b6eb7d6d275212fd68eb4ca7a45c9d31ffe4a3d706bd318f9d0016"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sqlite3-0.1.2"
    cellar :any_skip_relocation
    sha256 "6dd873a9acb48be2510892aed88449dfcba6e6d616d8da1a5abd249e00da1a7c" => :catalina
    sha256 "951093517fc1a8c289244c8e7d625a8dff423f2116a7b31e11e2cc0ad801fd71" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "sqlite"

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
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
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
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", sqlite3
  end
end
