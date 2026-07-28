class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.6.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.6.0/ardvark-darwin-arm64"
      sha256 "eb1893f6bff98acc18b34b3d177dd2d4e7c83f41443ce079e099ea4f6837d496"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.6.0/ardvark-darwin-amd64"
      sha256 "f34f49995f0e1da19dde66923e1d58b801ace87f8e37b1d83ef51b85efa54d9d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.6.0/ardvark-linux-arm64"
      sha256 "d3d0a57df2071459b637c6ce5e89a4c321f6a312d3a5d674ff27bfa86b02a51d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.6.0/ardvark-linux-amd64"
      sha256 "a3e45801dd9c46a7d1b16c8ebf2372020b0ad09de45666a926699682b502fae9"
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
