# Homebrew formula for Silimon
# Auto-updated by GitHub Actions

class Silimon < Formula
  desc "Apple Silicon performance monitor for your menu bar"
  homepage "https://github.com/odfalik/silimon"
  url "https://github.com/odfalik/silimon/releases/download/v0.4.1/silimon-0.4.1-arm64.tar.gz"
  sha256 "e399e98d229f523dc07987cbcb007b8f8405d6e9e9a724e788fa7a49e65e60da"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "silimon"
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
