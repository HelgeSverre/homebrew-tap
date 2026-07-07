class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.4"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.4/jake-macos-aarch64"
      sha256 "4c0b01db0540972661928f423c183fcd41f428bce988d8ea7834fcbf4d6ef8e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.4/jake-macos-x86_64"
      sha256 "fa5bfa897aff74bc832b9354ca4664c967842632188ac15d22c1e0fc06a8c13e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.4/jake-linux-aarch64"
      sha256 "38f30f1c476a9d1a4de2d6da618eeac0d08b6a7dfe5d504c50ced2971dc9b575"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.4/jake-linux-x86_64"
      sha256 "03ed3c14a1d2f0479384cfdba69c3badeb2b5755b6521a2ed07827542335c681"
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
