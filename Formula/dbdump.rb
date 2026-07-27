class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.4.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.1/dbdump-v1.4.1-darwin-arm64.tar.gz"
      sha256 "3c2c2fce1a2ffc2afccf8982b4edb2f5fc6833b0a491258e909585690a5f0ff3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.1/dbdump-v1.4.1-darwin-amd64.tar.gz"
      sha256 "139ed0db20ff2ea8a01788be20ce826610bbbbafd7d0aa9082cb11ba424127d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.1/dbdump-v1.4.1-linux-arm64.tar.gz"
      sha256 "85b144148a1907b03001750a09180c1b7d0b9e9b82001349833077946fe2fa4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.1/dbdump-v1.4.1-linux-amd64.tar.gz"
      sha256 "34c86b4fea142d54c35f69818d9e78b54a8672fffaf9d52f497365ea1ffe8d2f"
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
