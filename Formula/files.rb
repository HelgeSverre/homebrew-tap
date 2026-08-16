class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.2/files-macos-arm64.tar.gz"
      sha256 "e6d149d8bd29a37f57c4aef819977e9e80936636dd76f5c2ffc18c362bbf9f5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.2/files-macos-x86_64.tar.gz"
      sha256 "aa57789bd8604ce76701934f60f4b4ce8a7208aace51d19c191b307e4bf23391"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.2/files-linux-arm64.tar.gz"
      sha256 "bf685633a74d335c58f18802e24ca92600eb5e98ee2b86f23557a567302b54a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.2.2/files-linux-x86_64.tar.gz"
      sha256 "c9ce26f4ae6dce73dd85ca31cb207079f64b1a313bcc3e0e6d0270d1a26d9b7e"
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
