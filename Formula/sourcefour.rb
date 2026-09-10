class Sourcefour < Formula
  desc "A fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.0/sourcefour-aarch64-apple-darwin.tar.xz"
      sha256 "e982959726fdf6e8e558fa615bac51fcea56dee43283f6090b6e997db69d0b9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.0/sourcefour-x86_64-apple-darwin.tar.xz"
      sha256 "bbf25c642a2715de228d070d16d3eab72f3ac3d82486892f78fd98d997cf15bd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/sourcefour/releases/download/v0.1.0/sourcefour-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "415f392a2579c8aaf1ae9507599296385ee00353ebe95929c812c23577dcec41"
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
