class GuileSqlite3 < Formula
  desc "Guile bindings to SQLite3"
  homepage "https://codeberg.org/guile-sqlite3/guile-sqlite3"
  url "https://codeberg.org/guile-sqlite3/guile-sqlite3/archive/v0.1.3.tar.gz"
  sha256 "158cb82958c6329319f911412999ea125980f327f54185bf0dad271d6f8f45c2"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-sqlite3-0.1.3_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f73eeb0c25f7026200a5a56536d71777e17abd802bca8b5dc9a673cd9f395f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c073344d448bb592780601e2bf0466dd5665636a397773b36a061548b9fb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805807bf28a4692a590de957e620705f2b6a1342c926ba4d59281197096e2c26"
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
