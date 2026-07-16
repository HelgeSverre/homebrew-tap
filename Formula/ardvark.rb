class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.4.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.1/ardvark-darwin-arm64"
      sha256 "683917a507df3c23d959070f0104163409c93d420afa2e8c35163fd9fc4fade0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.1/ardvark-darwin-amd64"
      sha256 "717556c4bd20949d839df6226f6035cf27b92211aafbbbc1a32e464caef4a515"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.1/ardvark-linux-arm64"
      sha256 "23f406dad054f6d82e4f97a3a9fed94bdc7c65b2890c598a2c79968c2b909162"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.1/ardvark-linux-amd64"
      sha256 "ea8f652326bbbc033049efca8c3344fb47da5a7fdac3eaaccfa672051804f1a2"
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
