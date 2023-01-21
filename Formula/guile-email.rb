class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.3.0.tar.lz"
  sha256 "82559411737975be73b916533bb5bb9974b7c393e57e9d84f47c4701b0deb709"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.3.0_1"
    sha256 cellar: :any_skip_relocation, monterey:     "30a8a2439a597bdf2b5f2c135bddc2442588b95c0edf524d8d1296309eb84266"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9478999c743ef043313ef59ddcc69efdc970f9eb4b449001eb8e250acc86337"
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
