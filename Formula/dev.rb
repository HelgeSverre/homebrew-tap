class Dev < Formula
  desc "Zero-setup command discovery and launcher for software projects"
  homepage "https://github.com/HelgeSverre/dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.1/dev-launcher-aarch64-apple-darwin.tar.xz"
      sha256 "c65301ce0c7e2614ac888f37034ce6dfa236675f69a27334229b36031887074e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.1/dev-launcher-x86_64-apple-darwin.tar.xz"
      sha256 "abf8408662d823075c52c9f1aac02dbf024e1c85920a37b7c74f00bb3d9e3ae5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.1/dev-launcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc90563db4cfa70dba4fd1793eab0e466f84f896173fa0ef16ce8cf0dc2d038b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/dev/releases/download/v0.1.1/dev-launcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae5e43ecb670e1c6274dcf97ca4de27d2ae008a2f817de597678df979d0f6c87"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dev"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dev"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dev"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dev"
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
