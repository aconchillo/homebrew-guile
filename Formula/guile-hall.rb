class GuileHall < Formula
  desc "Hall is a project manager for Guile modules and applications"
  homepage "https://gitlab.com/a-sassmannshausen/guile-hall/"
  url "https://gitlab.com/a-sassmannshausen/guile-hall/-/archive/0.3.1/guile-hall-0.3.1.tar.gz"
  sha256 "b8b1b7c9613217cb4df8ffe22a5e821c40cd5c9ce3de4ca6ad61fc9bb9e5f38e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hall-0.3.1"
    cellar :any_skip_relocation
    sha256 "168737153681dbe5084df0758212ae234f94dfd5384d5da21113419e510c09ea" => :catalina
    sha256 "01a7f3941653cdfb11af712115928e7b12d7058d88290cfea1d53e366842eed3" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-config"

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
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "hall"
  end
end
