class Dbdump < Formula
  desc "Intelligent MySQL database dumping tool"
  homepage "https://github.com/helgesverre/dbdump"
  version "1.3.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.2/dbdump-v1.3.2-darwin-arm64.tar.gz"
      sha256 "1a84e14153fa505ea6dd6ec7b0b34c6119a16136598b24e3e1c23c89b9126f99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.2/dbdump-v1.3.2-darwin-amd64.tar.gz"
      sha256 "569f0dbd51b55c5c6b56936c18931e2591a2cf98543adaa03c5674fc70debe90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.2/dbdump-v1.3.2-linux-arm64.tar.gz"
      sha256 "2f641d863927155aece7481b4a6662f5601f98721c4d04ab36e7691b166ce544"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/dbdump/releases/download/v1.3.2/dbdump-v1.3.2-linux-amd64.tar.gz"
      sha256 "b0417af3607e2d138d8faf7a77733ccd410890f04d10fe862bb0a869ee492813"
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
