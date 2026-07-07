class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.5"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.5/jake-macos-aarch64"
      sha256 "1e7b28d252c88f02709f364f52a85de22d7bf63ee32b67d12426a8ca2684b147"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.5/jake-macos-x86_64"
      sha256 "43eeafa6bf6820cd5e9daaff7550cef5c3bf59485d232668c9f35cc31e08426b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.5/jake-linux-aarch64"
      sha256 "8f6fae02814e438328a3167f54b172d8b375e37f59962ef2e5352b1a8d59f039"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.5/jake-linux-x86_64"
      sha256 "12199ef5802e22b1ec5642227194f687eb3d329e02eb9089e8e2d96bb12dc25b"
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
