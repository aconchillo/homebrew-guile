class GuileGi < Formula
  desc "Bindings for GObject Introspection and libgirepository for Guile"
  homepage "https://github.com/spk121/guile-gi/"
  url "https://github.com/spk121/guile-gi/releases/download/v0.3.2/guile_gi-0.3.2.tar.gz"
  sha256 "7e35b9b661e331a45bc44f4e4093b748693c603de94d728098a7a8e71f5c3505"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-gi-0.3.2_3"
    sha256 arm64_tahoe:   "39cb28754bce645d51e5e7234bbdcffc03b95c48ae5d064160382e6c216f0eb1"
    sha256 arm64_sequoia: "3931bb07cfcafb986abe02b5569811c713748297fb8098c54475fcad5bce1738"
    sha256 x86_64_linux:  "c3b3a1b890429d696bf396351e7ee50e6a572995651fb7215e07dfee9fa35e51"
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "guile"
  depends_on "libffi"

  on_macos do
    depends_on "bdw-gc"
    depends_on "gettext"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

    system "./configure",
           "--prefix=#{prefix}",
           "--with-gnu-filesystem-hierarchy"
    # The test sources are copied from gobject-introspection, which no longer
    # ships them, and they are not needed to build or install the library.
    system "make", "install", "BUILT_SOURCES="
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
