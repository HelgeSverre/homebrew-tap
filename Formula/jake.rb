class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.8"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.8/jake-macos-aarch64"
      sha256 "72f05dc4bff419a256eb47b802b3787639a3ea1262e48774d1664eaa8ffa0df5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.8/jake-macos-x86_64"
      sha256 "beecc7bf9f5675b6f32b0e7d9b84e6530be32faf6331e5f7555f93e6cba2b1f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.8/jake-linux-aarch64"
      sha256 "9faf96e4125289f818e39780cca3108b078a5ad0fa56e83c0f44f74575a4a0b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.8/jake-linux-x86_64"
      sha256 "645e9c6ff03444cf2775cb8094479e317ccf6d41482fbc7639c90787f3950c98"
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
