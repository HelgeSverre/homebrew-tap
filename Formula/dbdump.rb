class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.5.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.0/dbdump-v1.5.0-darwin-arm64.tar.gz"
      sha256 "74f20fd7e25ddaf67d3445b6c01b8939966ed73676271d3b0421659c2b840fdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.0/dbdump-v1.5.0-darwin-amd64.tar.gz"
      sha256 "be092a702d21f2537e24a47ebc1a04366f7fb32b6b7ef3ee7757c4fc83391fee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.0/dbdump-v1.5.0-linux-arm64.tar.gz"
      sha256 "6956859fcce0929d22766f1320c4bb6da0edd8e103085e89eb5835147afe4cac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.0/dbdump-v1.5.0-linux-amd64.tar.gz"
      sha256 "6af182d5926be8d46a286bc498f8e04b12d54ac904869c31013a339804fccded"
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
