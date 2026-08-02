class Strek < Formula
  desc "A native vector editor for logos and icons"
  homepage "https://github.com/HelgeSverre/strek"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.1.0/strek-aarch64-apple-darwin.tar.xz"
      sha256 "5176c5f438150defe30d1b8445b9604750d39a3ad854c7cbe67ab171dc6bef53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.1.0/strek-x86_64-apple-darwin.tar.xz"
      sha256 "4aed8bccfe0a258cca274d919377f48126fb440ffe94e17f9b18ac444d67e50f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.1.0/strek-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "329517276d407f7a7a51d8928ef124c74c4ffc183641abec5235d7c0342d373a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.1.0/strek-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "daf0ac6b28160b0ec03448d63639d2ddbae4be860f37f200736df86e37102c24"
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
    bin.install "strek" if OS.mac? && Hardware::CPU.arm?
    bin.install "strek" if OS.mac? && Hardware::CPU.intel?
    bin.install "strek" if OS.linux? && Hardware::CPU.arm?
    bin.install "strek" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
