class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.2/jake-macos-aarch64"
      sha256 "1edb172c9819ab6ac8b1862ca229a9cbef2a2b078668a316181bb15499330672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.2/jake-macos-x86_64"
      sha256 "de5419cfec38698911fe7b58b80c1f2b120e62332f6d3438c4156a954c8e0061"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.2/jake-linux-aarch64"
      sha256 "53ef29dc3c668ec80c79f506a18ad8c7c2c370c9019c477e8223e30bc12e9207"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.2/jake-linux-x86_64"
      sha256 "f6b59cbd6942bdd68affcbc854fbf779c877a34b0957ad8f41f05527811a5901"
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
