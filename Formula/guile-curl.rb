class GuileCurl < Formula
  desc "Guile bindings for the CURL network client library"
  homepage "https://github.com/spk121/guile-curl"
  url "https://github.com/spk121/guile-curl/archive/refs/tags/v0.10.tar.gz"
  sha256 "8c25bfc1d95227b22b9f48df971be748486b9e2ea0b4e33944ce8aaf9baffd4c"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-curl-0.9_2"
    sha256 cellar: :any, arm64_tahoe:   "a005cd2db74dcb1add85c88e808dba089090db07252efc04c007aa328366b2df"
    sha256 cellar: :any, arm64_sequoia: "a63544b9c82b5d6b152980328edee1a9910d0da985b85c9b89f018a05658a61b"
    sha256 cellar: :any, x86_64_linux:  "acb905083d18dfcdd1e8b124c966b4fd073f894e2ac8c62d52becff7a5c01a57"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "curl"
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"
    # guile.m4's GUILE_FLAGS needs AC_LIB_LINKFLAGS_FROM_LIBS from gettext.
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

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
    curl = testpath/"curl.scm"
    curl.write <<~EOS
      (use-modules (curl))
      (curl-easy-init)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", curl
  end
end
