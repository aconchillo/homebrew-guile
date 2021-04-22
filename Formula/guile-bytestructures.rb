class GuileBytestructures < Formula
  desc "Library for structured access to bytevector contents"
  homepage "https://github.com/TaylanUB/scheme-bytestructures"
  url "https://github.com/TaylanUB/scheme-bytestructures/releases/download/v1.0.10/bytestructures-1.0.10.tar.gz"
  sha256 "bb8a78c1e570f90e344368196844ee0f143682b3d4c6ab69d6de0fa0d7b7c20d"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bytestructures-1.0.10"
    sha256 cellar: :any_skip_relocation, catalina:     "f3144099b3bbb5652486f939dde065966c63b4fd86a03eba348b1a5c9d065fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68962a5ad51a78be435ac11ee8caf9ee62cdc94ca6f51cb3c81420e8e31e8f23"
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

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
    bytestructures = testpath/"bytestructures.scm"
    bytestructures.write <<~EOS
      (use-modules (bytestructures guile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", bytestructures
  end
end
