class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.3"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.3/jake-macos-aarch64"
      sha256 "38402c6dcf5be26892e3aefd914d1299ff4dcec560c394eca22fc7582592e085"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.3/jake-macos-x86_64"
      sha256 "796bbd3203c2f94d530556a4280ed333bd19c4624f0dc57c0d5f324ff5a6a973"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.3/jake-linux-aarch64"
      sha256 "38826e7c0fcd7dfa16dcdf8b3025c399cc1d4d840acbfb71af21bcb4b529cfba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.3/jake-linux-x86_64"
      sha256 "b88669b3a7e4167dcf1085963f47e35cbbb3b1e3989c61f67d8ec1487deee79c"
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
