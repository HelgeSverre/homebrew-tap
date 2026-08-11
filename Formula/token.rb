class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.5.1/token-aarch64-apple-darwin.tar.xz"
      sha256 "026bc3ecd10164240d429fdd304e12f3c03117df1367cf888b760fa96a2a21f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.5.1/token-x86_64-apple-darwin.tar.xz"
      sha256 "1cdcb1ccffdb53439d8eab076fc38b62229787632162d85243540dc97697fb15"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/token/releases/download/v0.5.1/token-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5279fa8eb65a76aa5f8ecf24e62bbc131cdc721c040d50e17985b703e6dd440d"
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
      bin.install "profile_render", "screenshot", "token"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "profile_render", "screenshot", "token"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "profile_render", "screenshot", "token"
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
