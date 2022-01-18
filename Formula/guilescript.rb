class Guilescript < Formula
  desc "Guile to JavaScript compiler"
  homepage "https://github.com/aconchillo/guilescript"
  url "https://github.com/aconchillo/guilescript/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "54e47f3c4ce79b4d37b768e171a574a3cf851802c61e54a4332200d46c869136"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guilescript-0.0.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "534a7768eb9fe5091d6b846f9d2d7907a42271291aa2c504c94f5e3bffc3327e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4318da866684a421b0fe8639ae2f240a3b4de8ffbcd0aa7918ae374486680cfa"
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
    guilescript = testpath/"guilescript.scm"
    guilescript.write <<~EOS
      (use-modules (language guilescript compile))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", guilescript
  end
end
