class Sourcefour < Formula
  desc "A fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.9/sourcefour-aarch64-apple-darwin.tar.xz"
      sha256 "6656da44751df2c95010ed899bc0cd2dded1e0c18138e53b450b34f3cc507ef6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.9/sourcefour-x86_64-apple-darwin.tar.xz"
      sha256 "86d2406b50a1e41f6c25eec6d652fe2de0612aeddabc560a642134a0cf0e8f79"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.9/sourcefour-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fd68a5935b2e0c0664870284a04361cc4addc359a1b7e11b7c80ae8bd188a25f"
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
