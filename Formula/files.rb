class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.4/files-macos-arm64.tar.gz"
      sha256 "5a4b8c33fd85917f0657f7d2b233dd015db2cc9d74e9340ceadea7ecbbd45456"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.4/files-macos-x86_64.tar.gz"
      sha256 "9b353dfad071f3a8f178f35845a076c48e859c7504bc291d35b3887c73a4558a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.4/files-linux-arm64.tar.gz"
      sha256 "5fd70a32631251ab270238083fd1bd4bf84f2db0776d0bd208ee33c2d205e640"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.4/files-linux-x86_64.tar.gz"
      sha256 "f02bf58afa4d9ef8b7b46602ebe571ab027fafc197c3aa7caccfb74d92aed402"
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
