class GuileGi < Formula
  desc "Bindings for GObject Introspection and libgirepository for Guile"
  homepage "https://github.com/spk121/guile-gi/"
  url "https://github.com/spk121/guile-gi/releases/download/v0.3.2/guile_gi-0.3.2.tar.gz"
  sha256 "7e35b9b661e331a45bc44f4e4093b748693c603de94d728098a7a8e71f5c3505"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gi-0.3.2_1"
    sha256 monterey:     "5a56819f824f43648dfd8c6e7d43c36f9b97408f0527e052640e8d9f1efccfec"
    sha256 x86_64_linux: "eba1da1ea593f0818d0e03da541b002b03e2931c6b5c08d870c42a074975672f"
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
