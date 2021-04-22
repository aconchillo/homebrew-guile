class GuileGi < Formula
  desc "Bindings for GObject Introspection and libgirepository for Guile"
  homepage "https://github.com/spk121/guile-gi/"
  url "https://github.com/spk121/guile-gi/archive/v0.3.1.tar.gz"
  sha256 "be503a7de9557aa7cf9c3fe36cc6578a6aa98323cf5db3a34c0d699878c0582e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gi-0.3.1"
    sha256 catalina:     "6a8ba8777fdc582f902fac498542405cf5e7786896702f7a1f934cca4fa7ae86"
    sha256 x86_64_linux: "7436ed8fcd68c7d1b520f9c4721aad519630746a4aeda70a55cbbf32b0898826"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "guile"
  depends_on "libffi"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./bootstrap"
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
