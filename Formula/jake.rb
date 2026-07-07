class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.6"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.6/jake-macos-aarch64"
      sha256 "dd38a337782a5abe3282ea38cd9f73d5cda0918d7973c8e3d2fc06f48f2feca9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.6/jake-macos-x86_64"
      sha256 "c15a6a4fcb28b640947e594bf2fabdeade9f49434a4b264c34b493baea747106"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.6/jake-linux-aarch64"
      sha256 "fc043f4877761b7f4d0c32dfdfc5a69c020822dea21e68934e57ace2750c6ca1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.6/jake-linux-x86_64"
      sha256 "9088b1ed0e2b35e19d2eeb2dbfa8cd46b9b7886f7029f37d3e0095e63ee1a666"
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
