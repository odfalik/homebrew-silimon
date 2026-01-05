# Homebrew formula for Silimon
# Auto-updated by GitHub Actions on new releases

class Silimon < Formula
  desc "Apple Silicon performance monitor for your menu bar"
  homepage "https://github.com/odfalik/silimon"
  url "https://github.com/odfalik/silimon/releases/download/v0.8.19/silimon-0.8.19-arm64.tar.gz"
  version "0.8.19"
  sha256 "a11fe906b0d7a64e3dd8c53cce83cabdc03b07293bd84712be1b6c9316f79d21"
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
