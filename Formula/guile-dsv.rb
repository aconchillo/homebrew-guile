class GuileDsv < Formula
  desc "Guile module for delimiter-separated values (DSV) data format"
  homepage "https://github.com/artyom-poptsov/guile-dsv"
  url "https://github.com/artyom-poptsov/guile-dsv/archive/v0.6.0.tar.gz"
  sha256 "8e0f9f9a80dd0cdfc418290741fc977b848f657367de686ffeb6cda6af767a59"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-dsv-0.5.2"
    sha256 monterey:     "029d72f3111f84e3d42a2e3efd47ded02201fd1983cbc6a00b844c3800a3b169"
    sha256 x86_64_linux: "b4caa24c31d46febc340757b1b09e396500bb865c8dd455b4d0ed93a0b1c7b96"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-lib"
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
