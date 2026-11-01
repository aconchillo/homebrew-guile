class Ploticus < Formula
  desc "Scriptable plotting and graphing utility"
  homepage "https://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"
  revision 1

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/ploticus-2.42_1"
    sha256 arm64_tahoe:   "bda412bb618bd00895bc8f0fb4d3ad3c8b48f46f4a23753679eae373cc864acb"
    sha256 arm64_sequoia: "9b599a8bbcc32063b96f3fc06c411a807880f296bf35ce4f519210dfd003a973"
    sha256 x86_64_linux:  "b72d47d0b636ceec881b8cb3fb739a21aa60633e410ab683d043c3404169a670"
  end

  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
