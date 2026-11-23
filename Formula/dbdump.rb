class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.5.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.1/dbdump-v1.5.1-darwin-arm64.tar.gz"
      sha256 "6d9b9c713191614dbbc3b7deeea522a7e777933aa6cd5257ee99029ceed2c7bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.1/dbdump-v1.5.1-darwin-amd64.tar.gz"
      sha256 "248d2b8eec1960491afb03ff92e67884449911e7a683de54bc6c9deedf91e37d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.1/dbdump-v1.5.1-linux-arm64.tar.gz"
      sha256 "35c78974bd4e54d9028cbce4727338bb57bfc991f143f0700bb5b9996be5a9c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.5.1/dbdump-v1.5.1-linux-amd64.tar.gz"
      sha256 "65fb86dab9568d8d7a1106b29f9c8acf51a8e3f7e38ac26101b9d00efef5e6a5"
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
