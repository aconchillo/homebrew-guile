class GuileBytestructures < Formula
  desc "Library for structured access to bytevector contents"
  homepage "https://github.com/TaylanUB/scheme-bytestructures"
  url "https://github.com/TaylanUB/scheme-bytestructures/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "b0681daa006c80efd2fce5dc174ac439d44be8a9c2e70938e497efad08cd5659"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bytestructures-2.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb473488cd4a6cf8adc4110ebae0ce2d96266351b50ddc0c8944667d86cb3105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37327541f5575b5e7d223582e17ee4bd1acd7063866324c3c014ced127a35159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed21acd26324e2ef602d2e99186638612090133862fac0769ac9315a54324dcc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

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
