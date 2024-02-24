class GuileNewt < Formula
  desc "Guile bindings for Newt"
  homepage "https://gitlab.com/mothacehe/guile-newt"
  url "https://gitlab.com/mothacehe/guile-newt/-/archive/0.0.3/guile-newt-0.0.3.tar.gz"
  sha256 "0a8381c23a7de31ce9fd9457fbff85d6e373f52ce72a7835b39250d9d0c370e8"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-newt-0.0.2"
    sha256 cellar: :any_skip_relocation, big_sur:      "e0f819581eb6d70556e317d171633da5903c736f43c3ee393d83cc80abaa0af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f930223d70681a8ea791aa46c03dbf02d85776b9dfca80d5e4af965afe6a0b6e"
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
