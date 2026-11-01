class GuileNewt < Formula
  desc "Guile bindings for Newt"
  homepage "https://gitlab.com/mothacehe/guile-newt"
  url "https://gitlab.com/mothacehe/guile-newt/-/archive/0.0.3/guile-newt-0.0.3.tar.gz"
  sha256 "0a8381c23a7de31ce9fd9457fbff85d6e373f52ce72a7835b39250d9d0c370e8"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-newt-0.0.3_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52ed18fb41f387c230556d0356a313e6f0d9279dd6adad72618519d472df93b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83f5f543cfa88673dde82e9e4fcb8961d2c732a6a51cbca2483c297db5ebd66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf4bb4836df4d9dc63b77897a6e18f37ced4250502fd0ba2cc444c9346e1afe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "newt"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    system "./bootstrap"
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
    newt = testpath/"newt.scm"
    newt.write <<~EOS
      (use-modules (newt))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", newt
  end
end
