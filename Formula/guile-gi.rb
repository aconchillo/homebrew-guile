class GuileGi < Formula
  desc "Bindings for GObject Introspection and libgirepository for Guile"
  homepage "https://github.com/spk121/guile-gi/"
  url "https://github.com/spk121/guile-gi/releases/download/v0.3.2/guile_gi-0.3.2.tar.gz"
  sha256 "7e35b9b661e331a45bc44f4e4093b748693c603de94d728098a7a8e71f5c3505"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gi-0.3.2_2"
    sha256 arm64_sonoma: "b7740b723bca04fbf7e6dcffff2c85873c4d8bdcb67227aba18584c879918f95"
    sha256 ventura:      "854910107edd64fc94266993dced4f52a05ccd505250285b3d3de2ae3008b58e"
    sha256 x86_64_linux: "394b4bd8bdc623f93feeb0b4dace485a3364c66761d660e8179c26839d2121a7"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "guile"
  depends_on "libffi"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./configure",
           "--prefix=#{prefix}",
           "--with-gnu-filesystem-hierarchy"
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
    gi = testpath/"gi.scm"
    gi.write <<~EOS
      (use-modules (gi) (gi repository) (gi types) (gi util))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gi
  end
end
