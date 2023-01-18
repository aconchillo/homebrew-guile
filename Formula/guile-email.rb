class GuileEmail < Formula
  desc "Collection of email utilities"
  homepage "https://guile-email.systemreboot.net/"
  url "https://guile-email.systemreboot.net/releases/guile-email-0.3.0.tar.lz"
  sha256 "82559411737975be73b916533bb5bb9974b7c393e57e9d84f47c4701b0deb709"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/guile-email-0.2.2"
    sha256 cellar: :any_skip_relocation, catalina:     "3a3cd8d22719c6b80ad5713db263960063bc5ba357d4a9aebbbabd89c907e2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d0035366ac6662442037c3eb550f21d0b125fc92f34060b3bfd8101a282e0089"
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
index cc69eed..5a5f72d 100644
--- a/Makefile
+++ b/Makefile
@@ -48,8 +48,8 @@ distribute_files = $(sources) tests $(doc_texi) \
 		   COPYING NEWS README.org \
 		   guix.scm Makefile

-scmdir = $(datarootdir)/guile/site/$(guile_effective_version)
-godir = $(libdir)/guile/$(guile_effective_version)/site-ccache
+scmdir = $(datarootdir)/guile/site/$(guile_effective_version)/email
+godir = $(libdir)/guile/$(guile_effective_version)/site-ccache/email

 .PHONY: all check install clean dist

@@ -90,9 +90,10 @@ $(dist_archive): .git/refs/heads/master
 	$(GPG) --detach-sign --armor $<

 install: $(doc_info)
-	mkdir -p $(scmdir) $(godir)
-	cp --parents -vr $(sources) $(scmdir)
-	cp --parents -vr $(objects) $(godir)
+	install -d $(scmdir)
+	install $(sources) $(scmdir)
+	install -d $(godir)
+	install $(objects) $(godir)
 	install -D $(doc_info) --target-directory $(infodir)

 clean:
