class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.2.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.2.0/ardvark-darwin-arm64"
      sha256 "2e42547aef79ab37aa0ca0199323b3d06ed80d5c5aa77763bd98001288385405"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.2.0/ardvark-darwin-amd64"
      sha256 "a2ea94e40ac6684cb150e323d66452eabbb0fcab40a346f46b3f8a4a2a5d8c76"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.2.0/ardvark-linux-arm64"
      sha256 "3dd44bf7f168b3ac06455f6da0b660b089647859ce6cb24e1371e4472c00f25c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.2.0/ardvark-linux-amd64"
      sha256 "784f897511e7b2d4ba0b3cee8ec9bc013a8313a06b7c2e08b613facc23c5311a"
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
