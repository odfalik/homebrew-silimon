# Homebrew formula for Silimon
# Auto-updated by GitHub Actions on new releases

class Silimon < Formula
  desc "Apple Silicon performance monitor for your menu bar"
  homepage "https://github.com/odfalik/silimon"
  url "https://github.com/odfalik/silimon/releases/download/v0.8.34/silimon-0.8.34-arm64.tar.gz"
  version "0.8.34"
  sha256 "9fdd94c29e61feffe81825a0ef6bd04b66615fadf914b74a3af4bf761af023af"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    bin.install "silimon"
  end

  def caveats
    <<~EOS
      Silimon monitors Apple Silicon performance metrics in your menu bar.

      Features:
        - Real-time power consumption (CPU, GPU, ANE)
        - CPU cluster frequencies (E-cores vs P-cores)
        - Memory usage and pressure
        - GPU utilization
        - Network throughput
        - Battery status

      No sudo required! Start silimon with:
        silimon

      If metrics are not working, open Settings and click "Diagnose"
      to run system diagnostics.
    EOS
  end

  test do
    assert_match "silimon", shell_output("#{bin}/silimon --version")
  end
end
