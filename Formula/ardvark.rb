class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.4.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.0/ardvark-darwin-arm64"
      sha256 "3b361af4adc6b1cdbe652321aeb3926bd74dc3c0f2db675f9b45c96fdb5808bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.0/ardvark-darwin-amd64"
      sha256 "a0963cb5f0a64a8fbc9766c988ff9d8d5db043bf709664c600356b2102843324"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.0/ardvark-linux-arm64"
      sha256 "eb42c5ff92050da4ea07f6174866335e288a6c9edee30a419fcabe66e47a8c35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.4.0/ardvark-linux-amd64"
      sha256 "15dcff740fca6f287e5e6a60316d9319c5fc1fa07bbecc227ec992d470cf80c3"
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
