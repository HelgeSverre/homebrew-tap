class Sourcefour < Formula
  desc "A fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.5/sourcefour-aarch64-apple-darwin.tar.xz"
      sha256 "5161bcb535142bc2b9b8616ff25816477b33a649837facb2eb8e64002f657c68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.5/sourcefour-x86_64-apple-darwin.tar.xz"
      sha256 "9a7bba3ff09aa5dd8a2dcea310ae5fdde9c24af1010083208931c212088991f4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.5/sourcefour-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0002e475c164d7da74937113c662bad9c3b5802394f42a7b31c5623e6565db89"
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
