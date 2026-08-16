class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.1/files-macos-arm64.tar.gz"
      sha256 "45aa9340d0fee6f435300fc3b2b9c98c261a6150041504a934d633331ef1a457"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.1/files-macos-x86_64.tar.gz"
      sha256 "163d94f66d95d880cb5150de05665b01ea947de49e7ba13a5724ac7819c194e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.1/files-linux-arm64.tar.gz"
      sha256 "865ddce0ce38912a2bce4fe7265c5ae5c74e6903de3807247ddecd792c3ce627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.1/files-linux-x86_64.tar.gz"
      sha256 "aa2a4c3d8f3bfd6ea8142f8a70a90f3f98d3e98b9471faa2d25d102b22257e3a"
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
