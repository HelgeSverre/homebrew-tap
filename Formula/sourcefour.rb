class Sourcefour < Formula
  desc "A fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.8/sourcefour-aarch64-apple-darwin.tar.xz"
      sha256 "b41fcf186dee159595d57140302a0d71a1a2e325134e5a25ab0952d154d30e61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.8/sourcefour-x86_64-apple-darwin.tar.xz"
      sha256 "8a8e7ee462721c6f0f0ccc8eb1b7ac0ce5b2263f8b927781c7a9c39f5f5cbebd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.8/sourcefour-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1b58ac36914985f35c9b1b432dba0b9678df3fc390951b097549767df3bcce80"
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
