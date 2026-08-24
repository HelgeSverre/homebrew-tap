class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.5/files-macos-arm64.tar.gz"
      sha256 "d419587e330f1dcf37d683b8de0a5f227f12b057164b4af419f644f2346b5fd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.5/files-macos-x86_64.tar.gz"
      sha256 "1040905f2895fa16f2244d198491276a08b39d7b58cb5e80a32af22a0363b977"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.5/files-linux-arm64.tar.gz"
      sha256 "367ebe64c8ef213d765543962f6833a110f6f365c727fce92e45ff2f6cd1f09b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.5/files-linux-x86_64.tar.gz"
      sha256 "0ed64e29a3d1c23fc917f8f94ca8be5fcb422dc59efcd587ca3d90738952fbd6"
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
