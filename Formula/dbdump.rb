class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.4.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.2/dbdump-v1.4.2-darwin-arm64.tar.gz"
      sha256 "f111166dedffb8583ddd839146166daf1559ef29d14b998eea0313a2adb1ad94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.2/dbdump-v1.4.2-darwin-amd64.tar.gz"
      sha256 "4b9aa7eea8cdcec10c55ff4e15bfe67a104e895e077183f53433866d757d1bc8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.2/dbdump-v1.4.2-linux-arm64.tar.gz"
      sha256 "5401889c1b64982b2e8c4e62456303dbf91e5ae6a01ad0ee350de429abca52d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.4.2/dbdump-v1.4.2-linux-amd64.tar.gz"
      sha256 "f094342e1ee3f108d18f60414fee65dfa87aaa0ea1ed6dc8e84e7a96561b3f62"
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
