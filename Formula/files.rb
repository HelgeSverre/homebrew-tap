class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.6/files-macos-arm64.tar.gz"
      sha256 "095627f1ba245b431a9f105560632e90db33c4019a2099c7cc1eaddc6af0e772"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.6/files-macos-x86_64.tar.gz"
      sha256 "608c0ee80661bec32dedf00bd4ed8ed4ec73a1bc9b997b48ff5218e4a65ed07f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.6/files-linux-arm64.tar.gz"
      sha256 "0e6dd524e2350fb8d9c2f434aa5805ba5e224b413f1d4b9b2f51e9f427d655e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.6/files-linux-x86_64.tar.gz"
      sha256 "81f2a2bc2c00e58f0e7b7f7613388a2d80c9588ad7d09ce819453fd20e432ae7"
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
