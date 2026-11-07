class Files < Formula
  desc "Fast, git-aware directory tree for your terminal"
  homepage "https://github.com/HelgeSverre/files"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.3.1/files-macos-arm64.tar.gz"
      sha256 "f712fb46abf17a1f0c08870306d9c091197d9f7374f7470bdf8b5393ac3e8e77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.3.1/files-macos-x86_64.tar.gz"
      sha256 "59d01e29b7c7d9175668ada9c99e0084f0b854d507614a8305794ea27662ccce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/files/releases/download/v0.3.1/files-linux-arm64.tar.gz"
      sha256 "7d3dad8a2bec0cb3d33edf69e4e6de5a00845dfc9b4ffde9b80cd74f67a48059"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/files/releases/download/v0.3.1/files-linux-x86_64.tar.gz"
      sha256 "ee5e2f5410d20f06a72a5a4d054feb20f186aa7570e18ab37d0ca345fd43f50b"
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
