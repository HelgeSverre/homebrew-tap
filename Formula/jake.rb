class Jake < Formula
  desc "Modern command runner with dependency tracking, built with Zig"
  homepage "https://www.jakefile.dev/"
  version "0.9.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.1/jake-macos-aarch64"
      sha256 "5a499efb2ca3e51e71b2da73e67580262b82d33146ad25b9317ea1f99c3c5124"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.1/jake-macos-x86_64"
      sha256 "038320ff4d2021d79f284b5df0be666cb53dd39b933309455ac3c31b1885b074"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.1/jake-linux-aarch64"
      sha256 "65e5c6d997c18d8d4d3c30d99062f23dadd3d94f1e8ae9c6119c80eb18b9bd75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/jake/releases/download/v0.9.1/jake-linux-x86_64"
      sha256 "8f7e4168cea161f63a27bf218f105520ab02cf01bf0293cf9813ffca10ae52a6"
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
