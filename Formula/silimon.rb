# Homebrew formula for Silimon
# Auto-updated by GitHub Actions

class Silimon < Formula
  desc "Apple Silicon performance monitor for your menu bar"
  homepage "https://github.com/odfalik/silimon"
  url "https://github.com/odfalik/silimon/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2f8675f89222c0aba99d3bfeb6ec787df8a49955210d82f717327252d38408c3"
  license "MIT"
  head "https://github.com/odfalik/silimon.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/silimon"
    (pkgshare/"scripts").install "Scripts/setup-sudo.sh"
    (pkgshare/"scripts").install "Scripts/uninstall.sh"
  end

  def caveats
    <<~EOS
      Silimon monitors Apple Silicon performance metrics in your menu bar.

      To start silimon:
        silimon

      First run may require: sudo silimon
      Or run: $(brew --prefix)/share/silimon/scripts/setup-sudo.sh
    EOS
  end

  test do
    assert_match "silimon", shell_output("#{bin}/silimon --help 2>&1", 0)
  end
end
