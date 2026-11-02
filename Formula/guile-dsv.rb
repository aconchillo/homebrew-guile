class GuileDsv < Formula
  desc "Guile module for delimiter-separated values (DSV) data format"
  homepage "https://github.com/artyom-poptsov/guile-dsv"
  url "https://github.com/artyom-poptsov/guile-dsv/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "110c7a010eefcd993feccf31ae814110e5ceb4b8d8222d118d119773d42a01f0"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dsv-0.9.0"
    sha256 arm64_tahoe:   "cd79d20969e08d1bc8c9bb9e976be98804f0b526fed2218f4ae0a165aaef6766"
    sha256 arm64_sequoia: "fb4930fe5d471509e5652f53f2f8d49a4c0bb0a39977f819ea1f8d0d9ef9edfe"
    sha256 x86_64_linux:  "52bffa2a567e5032eb137655b0d1bd7a4a766d0b046bce7ac8cd20ac09b911e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
  depends_on "guile-smc"
  depends_on "help2man"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

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
    dsv = testpath/"dsv.scm"
    dsv.write <<~EOS
      (use-modules (dsv))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", dsv
  end
end
