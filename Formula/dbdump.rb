class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.3.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.1/dbdump-v1.3.1-darwin-arm64.tar.gz"
      sha256 "0989f7cd6a1fb74aab0161f0279681584c27e4b5cb8bac69eea9fc27a564a6f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.1/dbdump-v1.3.1-darwin-amd64.tar.gz"
      sha256 "f87c3eaf90c859df4c8fa781b908f00616313a76633644062b8d98fcb547dc30"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.1/dbdump-v1.3.1-linux-arm64.tar.gz"
      sha256 "08a9d64be30db6f36f217e7883baea8766bd0ecaf4bc556921da27de9c5b457c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.1/dbdump-v1.3.1-linux-amd64.tar.gz"
      sha256 "5ff0a0283f252b54755e80072188c661307d5a44f3235908b6fc158010cef438"
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
