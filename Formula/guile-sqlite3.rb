class GuileSqlite3 < Formula
  desc "Guile bindings to SQLite3"
  homepage "https://notabug.org/guile-sqlite3/guile-sqlite3"
  url "https://notabug.org/guile-sqlite3/guile-sqlite3/archive/v0.1.3.tar.gz"
  sha256 "158cb82958c6329319f911412999ea125980f327f54185bf0dad271d6f8f45c2"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sqlite3-0.1.3"
    sha256 cellar: :any_skip_relocation, catalina:     "e7fda70608fd77cb0a2b7ef8808db2fccbba1fb5533a9d3b9b2fa9a5c0fc64e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e02ba07d4d57b99e3458b807e7dbe91625dd1c1c1d4617432941b55b9e2013d"
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
