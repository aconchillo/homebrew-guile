class Haunt < Formula
  desc "Simple, functional, hackable static site generator"
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/haunt/haunt-0.2.5.tar.gz"
  sha256 "1324b7986897ca55b9150ae80f8241f4037075bc2bb5bbdae56385540d2dc4bf"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/haunt-0.2.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "8c4650432cd814cbab4b2734f593cdac9d3f8c88377ba5533cc31985142a1a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "25c0ea7f690eba15711ebd674b6edf95569cfa7879a0e853b4ff80a215aa4513"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-commonmark"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    haunt = testpath/"haunt.scm"
    haunt.write <<~EOS
      (use-modules (haunt site))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", haunt
  end
end
