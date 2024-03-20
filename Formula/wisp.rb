class Wisp < Formula
  desc "OAuth module for Guile"
  homepage "https://www.draketo.de/software/wisp"
  url "https://www.draketo.de/software/wisp-1.0.12.tar.gz"
  sha256 "1abed812c960b2f9f383b151bbd9758e6e24df56e181f00b9e04fd7b7d7c9a2e"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/wisp-1.0.11_2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "44a495656bd9b9fb1c6857d541c4d3600f83755b709f3ea161ec5a9d580c870e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
    wisp = testpath/"wisp.w"
    wisp.write <<~EOS
      display "Hello Homebrew!"
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", "--language=wisp", wisp
  end
end
