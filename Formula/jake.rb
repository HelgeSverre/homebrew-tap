class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.9"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.9/jake-macos-aarch64"
      sha256 "8d87940db157bab55e3eb04b979e0f48305bf8f201722b09dd15915103df64bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.9/jake-macos-x86_64"
      sha256 "1b0fdbec192560e3963f22b46a7e3f8992f4afc7f9ecd0a1dfc3cb7c2f389597"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.9/jake-linux-aarch64"
      sha256 "008dadd4f91dbab70bcc2f8bec9504f376feae722462f8702f4ac9e97a011634"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.9/jake-linux-x86_64"
      sha256 "4a751259e0b953de6d77aac1e06ebe2f1620fc3b12710753055c7fa1cbe76fb2"
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
