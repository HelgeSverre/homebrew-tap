class Sourcefour < Formula
  desc "A fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.1/sourcefour-aarch64-apple-darwin.tar.xz"
      sha256 "961f2194e22f45c58efb6a5ca247d6a7f0a5ecea8e24d7dc6d0aef20e8357488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.1/sourcefour-x86_64-apple-darwin.tar.xz"
      sha256 "fde35b27f5e404156da2df9c170fab1a358112f44c828c8a4a4d5e81454573ef"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.1/sourcefour-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3c8a90cab0d40be19c9bcf8eae98104b2d6fa9da2758b230210375f4b94d3e9e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sourcefour"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sourcefour"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sourcefour"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
