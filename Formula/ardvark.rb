class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.5.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.5.0/ardvark-darwin-arm64"
      sha256 "fac10e33eb3d92b2bbf2652d59254946b57f0dfca98c10f3c8993985ff10e112"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.5.0/ardvark-darwin-amd64"
      sha256 "8f322bdfe2061e6204bdb36f005ae12eb4d541bd7d3971546b3f0d3143d9ac23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.5.0/ardvark-linux-arm64"
      sha256 "444dabdf4fd9880f50ce4c0ca6b3ca8832eeacf603c09d77128cbcd31000eddd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.5.0/ardvark-linux-amd64"
      sha256 "ab669b53284d37c7ac593217671e30b5684f9f134633888bca3eb11f4493e01b"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "ardvark-#{os}-#{arch}" => "ardvark"
  end

  test do
    assert_match "ardvark", shell_output("#{bin}/ardvark --version")
  end
end
