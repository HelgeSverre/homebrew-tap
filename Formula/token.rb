class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.3.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.16/token-aarch64-apple-darwin.tar.xz"
      sha256 "7161762f0810154533059b90a8bc1976d1d1cfcf0d3fa4e3e2e2fc446a4ff748"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.16/token-x86_64-apple-darwin.tar.xz"
      sha256 "77b212e4170747996adc253c43e1fe59f14c0b74c759c65dacb1184fd3d29e2c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.16/token-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10c931c2ec8e8debb00f053c4a67a899118ba4edb7f0329b2f96fe84dd18cee1"
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
    bin.install "token" if OS.mac? && Hardware::CPU.arm?
    bin.install "token" if OS.mac? && Hardware::CPU.intel?
    bin.install "token" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
