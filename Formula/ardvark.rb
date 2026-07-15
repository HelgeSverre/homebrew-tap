class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.3.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.3.0/ardvark-darwin-arm64"
      sha256 "286d42382bf64f30a791bb058db370dda50788b5ef7b6c7aaa563b497ef46fc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.3.0/ardvark-darwin-amd64"
      sha256 "23ff91ef897867a4933d60389da8f459e08043a9b066999ecb8d17240028b54e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.3.0/ardvark-linux-arm64"
      sha256 "e458fc6ab336657e49a9e9b70203efdb581cb2fd539776299432ae9fd69a2c5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.3.0/ardvark-linux-amd64"
      sha256 "20941a6c20ca7b39c59730f3241862cb86a06c55ba2e203963f0f87d825fef57"
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
