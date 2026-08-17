class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.3/files-macos-arm64.tar.gz"
      sha256 "861f367ac2eb0c578e332f871975f624fbffb6ba3883d473c12a0cacb1665133"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.3/files-macos-x86_64.tar.gz"
      sha256 "e2a2dadbfdc7ab6b0c4e4e97cba11fb28377458f16c108d106de446be63f2b46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.3/files-linux-arm64.tar.gz"
      sha256 "def9206516edd585f9b2b54d6881c3cdc533421bd8819a91022a1150c54ff771"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.3/files-linux-x86_64.tar.gz"
      sha256 "2bad06abecbecfff29b4abebaa0c9e063dc9d71e9ecb26f7c2087d1fc7cdeba8"
    end
  end
  license "MIT"

  def install
    bin.install "files"
  end

  test do
    assert_match "files", shell_output("#{bin}/files --version")
  end
end
