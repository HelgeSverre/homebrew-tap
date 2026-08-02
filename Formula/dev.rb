class Dev < Formula
  desc "Zero-setup command discovery and launcher for software projects"
  homepage "https://github.com/HelgeSverre/dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.0/dev-launcher-aarch64-apple-darwin.tar.xz"
      sha256 "0cd57778d6ade6b3fad7450e94b4c6001ca73d014201994861d0a38acffc6a3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.0/dev-launcher-x86_64-apple-darwin.tar.xz"
      sha256 "7baed607c5cd84c439fab1c8a45848d41e155538d0f5ee74653abf2bd9ab5890"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.0/dev-launcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3ba2c546e444b6c803e1327d7c9d1befe43c35b74902333c838c61c0c482289"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.0/dev-launcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fe2fac1b4e1a92271a64937539b2019f4f63b6b7156e77610eae3c6f055fff45"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dev" if OS.mac? && Hardware::CPU.arm?
    bin.install "dev" if OS.mac? && Hardware::CPU.intel?
    bin.install "dev" if OS.linux? && Hardware::CPU.arm?
    bin.install "dev" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
