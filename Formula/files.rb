class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.4.0/files-macos-arm64.tar.gz"
      sha256 "ba9abe47b8dcbc13b6546fea67d7b2ec08a54da8169e44cb75b56681ab4b2dc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.4.0/files-macos-x86_64.tar.gz"
      sha256 "8050a78cdec50ef64cc9fef7f8ee08759451381437aabc10986bfb3c567e0eef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.4.0/files-linux-arm64.tar.gz"
      sha256 "4ca63e4966503cc57ce075dd191d381ed75208088a6a6ee7a5b9eb214062339d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.4.0/files-linux-x86_64.tar.gz"
      sha256 "195713bc3aa0f6b6431b7758de9d0e5b039178d9e348ce5ddd86dd97f437072f"
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
