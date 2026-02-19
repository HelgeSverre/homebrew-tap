class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.3.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.18/token-aarch64-apple-darwin.tar.xz"
      sha256 "d5ec01f73629a295376974555f6e1000a2317a7193ebcaf861ab9ab3d2752833"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.18/token-x86_64-apple-darwin.tar.xz"
      sha256 "a3b6e1928a19ca3ecf29b131a0ab29c8be504b4332bd8e9c263b78d72b6adf5a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.18/token-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f787c3fe39883543f2247330263fb4af48ca79cdcb35eadb1a08ac284c099440"
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
    bin.install "profile_render", "screenshot", "token" if OS.mac? && Hardware::CPU.arm?
    bin.install "profile_render", "screenshot", "token" if OS.mac? && Hardware::CPU.intel?
    bin.install "profile_render", "screenshot", "token" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
