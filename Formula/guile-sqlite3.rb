class GuileSqlite3 < Formula
  desc "Guile bindings to SQLite3"
  homepage "https://notabug.org/guile-sqlite3/guile-sqlite3"
  url "https://notabug.org/guile-sqlite3/guile-sqlite3/archive/v0.1.3.tar.gz"
  sha256 "158cb82958c6329319f911412999ea125980f327f54185bf0dad271d6f8f45c2"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sqlite3-0.1.3_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "becc28703d29a1c62fdf8e8b917feffab3e4b7978b611fb412b3f38e2e7f1169"
    sha256 cellar: :any_skip_relocation, ventura:      "768d5de6f8b52259130912828691686c9eef758a4a25c5aa4bddc0e7fbbe68be"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10fba3ba1963b7e60bd7088b3356557ac20d7518257f42594b4c6e49ecde1d0e"
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

    # Use Homebrew /usr/local/opt instead of Cellar.
    inreplace buildpath/"sqlite3.scm" do |s|
      s.gsub!(/\(define libsqlite3 .*/,
              "(define libsqlite3 (dynamic-link \"#{HOMEBREW_PREFIX}/opt/sqlite3/lib/libsqlite3\"))")
    end

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
