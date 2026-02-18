class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.3.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.17/token-aarch64-apple-darwin.tar.xz"
      sha256 "60cbd4541374eac9ebd328e4c514a23200e26efbc1d1ae4d526ba89d5c946fcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.17/token-x86_64-apple-darwin.tar.xz"
      sha256 "e808c41feaa24b0a2fa7094673e47120073a20d89e17bc3d648e74f26fa2b423"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.17/token-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3af706c234025f5c63b2950316046a8b0df8cbea646d28e9a719d5301bc60ea9"
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
