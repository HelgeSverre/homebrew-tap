class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.0/jake-macos-aarch64"
      sha256 "60ae6435318106a0ff0dfe2124bec12fae103247b9b9ce9d9cb0b05f1cc1c410"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.0/jake-macos-x86_64"
      sha256 "21171cd56fd6a5a3835086a9eb6acc263d56e8f7df6f391c1d1278ca56b5096f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.0/jake-linux-aarch64"
      sha256 "bd5e6b3fd0a24a6c79d06e78b8486bcb3301bd14fc3fa579525c26fed7282c7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.0/jake-linux-x86_64"
      sha256 "65209abea5273af8bd2f2b6f0654fac2b753980d56612d0654f7c62a7cf877e6"
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
