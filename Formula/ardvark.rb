class Ardvark < Formula
  desc "Crawler and indexer for ARD (Agentic Resource Discovery) ai-catalog.json documents"
  homepage "https://ardvark.no"
  version "0.7.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.7.0/ardvark-darwin-arm64"
      sha256 "d9f89f9f2884ece270d13215627b942f1c723bbdc0b80803678941520bc755b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.7.0/ardvark-darwin-amd64"
      sha256 "d9b44ec61eda5e1fa0bbb6fdef08cb691619ec03ec254aee2056cafafd16c839"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.7.0/ardvark-linux-arm64"
      sha256 "c1585e28de7c88df9ad39fb2be6426bb4c6570e68b7e4243f51a7869e984a2d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/ardvark/releases/download/v0.7.0/ardvark-linux-amd64"
      sha256 "4db88ab14c0f50bd6323711b9a7ee219ccd23a30c8938b26334a7553c5d51ddb"
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
