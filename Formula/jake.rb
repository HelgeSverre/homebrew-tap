class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.8.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.8.1/jake-macos-aarch64"
      sha256 "a4848ffbdf4382a65c628d1390bbd0c556437cc2ac2be5cfba71c7f5b14761b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.8.1/jake-macos-x86_64"
      sha256 "c978468aaa2d81907db03714cccedf99f5638f9fffbccb74a57f821ee281571f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.8.1/jake-linux-aarch64"
      sha256 "524ae568f6b7d3fd0d05424dc22f7a1a286bba27f2d4315b638eebb6909b90ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.8.1/jake-linux-x86_64"
      sha256 "962012f0f0be99b9d882abb3fce23ed8192cf3663bc2e06d9b14d01d5283300e"
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
