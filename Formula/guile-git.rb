class GuileGit < Formula
  desc "GNU Guile library providing bindings to libgit2"
  homepage "https://gitlab.com/guile-git/guile-git"
  url "https://gitlab.com/guile-git/guile-git/-/archive/v0.11.0/guile-git-v0.11.0.tar.gz"
  sha256 "91ffe50e595907ad49a3a6e8c24f87613ba2a6cf59730c8ad5be4d2ef8f041cd"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-git-0.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e87f3cc1f49ca6d85c283cf4ef780eadfff440551a0db37afb1c76359d54a996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e57c2d59e701ee71e9e00a70c49e6920239df9ec4d761f1bf59cf3d1c333dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f787d7e482e0fa084232c7c45191550dbd70c194cba2d1b44979301ca420ca87"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-bytestructures"
  depends_on "libgit2"

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

  post_install_steps do
    # Touch configuration.go to avoid Guile recompilation.
    touch "{{lib}}/guile/3.0/site-ccache/git/configuration.go"
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
    git = testpath/"git.scm"
    git.write <<~EOS
      (use-modules (git))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", git
  end
end
