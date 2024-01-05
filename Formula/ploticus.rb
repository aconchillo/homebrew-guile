class Ploticus < Formula
  desc "Scriptable plotting and graphing utility"
  homepage "https://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/ploticus-2.42"
    sha256 arm64_sonoma: "a07ba5cf7c465f72d5f2183113a77a9d4d01b32295332a094ace5a841d01a716"
    sha256 ventura:      "470e18c8b029406e11ac7946ad99e922757065a0aefb29464974471ee05f1e25"
    sha256 x86_64_linux: "69a3d4125b2539865bfdcda78871346132f0db668b20c660e7be0c5ceec88a01"
  end

  depends_on "libpng"

  def install
    # Use alternate name because "pl" conflicts with macOS "pl" utility
    args=["INSTALLBIN=#{bin}",
          "EXE=ploticus"]
    inreplace "src/pl.h", /#define\s+PREFABS_DIR\s+""/, "#define PREFABS_DIR \"#{pkgshare}\""
    system "make", "-C", "src", *args
    # Required because the Makefile assumes INSTALLBIN dir exists
    bin.mkdir
    system "make", "-C", "src", "install", *args
    pkgshare.install Dir["prefabs/*"]
  end

  def caveats
    <<~EOS
      Ploticus prefabs have been installed to #{opt_pkgshare}
    EOS
  end

  test do
    assert_match "ploticus 2.", shell_output("#{bin}/ploticus -version 2>&1", 1)

    (testpath/"test.in").write <<~EOS
      #proc areadef
        rectangle: 1 1 4 2
        xrange: 0 5
        yrange: 0 100

      #proc xaxis:
        stubs: text
        Africa
        Americas
        Asia
        Europe,\\nAustralia,\\n& Pacific
    EOS
    system "#{bin}/ploticus", "-f", "test.in", "-png", "-o", "test.png"
    assert_match "PNG image data", shell_output("file test.png")
  end
end
