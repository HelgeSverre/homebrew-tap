class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.4.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.0/dbdump-v1.4.0-darwin-arm64.tar.gz"
      sha256 "29aaa5642bdfc766f0b53410b79fc8288a769acd65b3e2d292fd50510f595d12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.0/dbdump-v1.4.0-darwin-amd64.tar.gz"
      sha256 "f7a01418038559ee7fad9c801900d7784909279523176696cc81ead657fe1d6a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.0/dbdump-v1.4.0-linux-arm64.tar.gz"
      sha256 "c27e4928575943157d4dceeb1593e580fb277df449e7b5951a582a40662c94b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.0/dbdump-v1.4.0-linux-amd64.tar.gz"
      sha256 "14f17e434d807cbdefff1ea4e345043ae4f55a131d6c7f6c1526c554f4735ca4"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "dbdump-#{os}-#{arch}" => "dbdump"
  end

  test do
    assert_match "dbdump is a CLI tool for intelligent MySQL database dumping", shell_output("#{bin}/dbdump --help")
  end
end
