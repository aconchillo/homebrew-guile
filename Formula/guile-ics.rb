class GuileIcs < Formula
  desc "RFC5545 (iCalendar) format parser for GNU Guile"
  homepage "https://github.com/artyom-poptsov/guile-ics"
  url "https://github.com/artyom-poptsov/guile-ics/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a18f6090f9919142c9129f0ef3f67ca3f0a0db47cc44201d36d6e7655189d1bc"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-ics-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "e2308260c7a6987aaa208311b19eb7d83934b32491acb22a7ea5b6703e0576e2"
    sha256 cellar: :any_skip_relocation, ventura:      "14ea363cc3c3c8889c1112266d5706b0c16f45f53293c2a156658c917ede9135"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d4f45638bcd9d679bf1ada9bee751dc9c8b3319128283814ea6acaac81c6ad80"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # coreutils because of install not working great on macOS 10.11. coreutils
  # will bring ginstall.
  depends_on "coreutils" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-smc"

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
    ics = testpath/"ics.scm"
    ics.write <<~EOS
      (use-modules (ics))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", ics
  end
end
