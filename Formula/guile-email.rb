class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.3.0.tar.lz"
  sha256 "82559411737975be73b916533bb5bb9974b7c393e57e9d84f47c4701b0deb709"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.3.0"
    sha256 cellar: :any_skip_relocation, monterey:     "f3ea285bc9feee70a8e143cc8aabe882b7bd5cfb78dd19ab5250b2aa7424980b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cf91ea3563f277204a27921aee10150e42be5fe0f96f58e311fd16ccc5f00883"
  end

  # coreutils because native `install` not working great
  depends_on "coreutils" => :build
  depends_on "texinfo" => :build
  depends_on "guile"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    inreplace buildpath/"Makefile", "install ", "ginstall "

    system "make"
    system "make", "install", "prefix=#{prefix}"
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
    email = testpath/"email.scm"
    email.write <<~EOS
      (use-modules (email email))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", email
  end
end

__END__
diff --git a/Makefile b/Makefile
index cc69eed..b7ed63e 100644
--- a/Makefile
+++ b/Makefile
@@ -90,9 +90,12 @@ $(dist_archive): .git/refs/heads/master
 	$(GPG) --detach-sign --armor $<

 install: $(doc_info)
-	mkdir -p $(scmdir) $(godir)
-	cp --parents -vr $(sources) $(scmdir)
-	cp --parents -vr $(objects) $(godir)
+	for source in $(sources); do \
+		install -D $$source $(scmdir)/$$source; \
+	done
+	for object in $(objects); do \
+		install -D $$object $(godir)/$$object; \
+	done
 	install -D $(doc_info) --target-directory $(infodir)

 clean:
