class GuileFScm < Formula
  desc "Library for working with files and directories"
  homepage "https://git.sr.ht/~brown121407/f.scm"
  url "https://git.sr.ht/~brown121407/f.scm/archive/0.2.0.tar.gz"
  sha256 "c4c2d4c395b7a54344c7fce3b74a7158b9cf812c4ae1a108c62761c34b503f3e"
  revision 1

  depends_on "guile"

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    load_path = Pathname.new "#{share}/guile/site/3.0"
    load_path.mkpath

    cp "#{buildpath}/f.scm", load_path
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
    f = testpath/"f.scm"
    f.write <<~EOS
      (use-modules (f))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", f
  end
end
