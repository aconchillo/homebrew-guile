class GuileHall < Formula
  desc "Hall is a project manager for Guile modules and applications"
  homepage "https://gitlab.com/a-sassmannshausen/guile-hall/"
  url "https://gitlab.com/a-sassmannshausen/guile-hall/-/archive/0.4.1/guile-hall-0.4.1.tar.gz"
  sha256 "8bf70fa795db3032be710a41fd316b92a87da2c2c909658412d0c36c4142e9be"
  revision 2

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-hall-0.4.1_2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "83122ba8842622da891d9426cd8c54d9495be3268b494bac774db67c0d205506"
    sha256 cellar: :any_skip_relocation, ventura:      "945f6d5ed07f0c167a0185f2cbbe5fd3dd755ac8fa4a8f7e781aac6e943bbb6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c56399547889a29346592ed94454888afd24eb648dcf383d5d6f3f926d03542"
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

    system "#{bin}/hall"
  end
end
