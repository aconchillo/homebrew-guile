class GuileBstructs < Formula
  desc "Library for structured read/write access to binary data for Guile"
  homepage "https://dthompson.us/projects/guile-bstructs.html"
  url "https://files.dthompson.us/releases/guile-bstructs/guile-bstructs-0.1.0.tar.gz"
  sha256 "8b1fe3d8f47f07ed0e5cd0d78c5e4df1c49d67c67eb22a45db34c3efa33a0439"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-bstructs-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "361430bd6e9cbdee123d2289122d5f26b79fb214b7452d72bf20f7564c2ea2d1"
    sha256 cellar: :any_skip_relocation, ventura:      "c7fb3d8e834d3404b2204a77a6b28cc985131e4c7d3655ae96661e636657d9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7aaf5374a8f604fe08e240f6043209cc46502468218f674eec67d5a7491cc3d3"
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
    bstructs = testpath/"bstructs.scm"
    bstructs.write <<~EOS
      (use-modules (bstructs))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", bstructs
  end
end
