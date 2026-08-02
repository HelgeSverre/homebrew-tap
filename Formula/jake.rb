class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.7"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.7/jake-macos-aarch64"
      sha256 "e858877976cb7935022debdc548cfdb8096e18957b29c7bf538a723027c66697"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.7/jake-macos-x86_64"
      sha256 "f7762b3bc3d7217060b6b3099471600d0ca3eb4da2d1db62c6b658d89f129dc8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.7/jake-linux-aarch64"
      sha256 "9f11247a1c8d98288d3ba9669e38d6cd278018c5fa93f765c83414da4f8d40db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.7/jake-linux-x86_64"
      sha256 "dde90f3fbeaf2d123e90277ca331441cac28cfc7b440e8578c47c58523237f66"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    bin.install "jake-#{os}-#{arch}" => "jake"
  end

  test do
    assert_match "jake", shell_output("#{bin}/jake --version")
  end
end
