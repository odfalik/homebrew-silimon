# Homebrew formula for Silimon
# Auto-updated by GitHub Actions

class Silimon < Formula
  desc "Apple Silicon performance monitor for your menu bar"
  homepage "https://github.com/odfalik/silimon"
  url "https://github.com/odfalik/silimon/releases/download/v0.4.0/silimon-0.4.0-arm64.tar.gz"
  sha256 "edfb9585b6b8b410e8b80a5cd6d152a75562368f5e31b4e656361b86408a1557"
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
