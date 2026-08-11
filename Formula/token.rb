class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.5.0/token-aarch64-apple-darwin.tar.xz"
      sha256 "630554aa998b05985b4eecbb4b02ccecdea8418af713abaffc4e4f118fe4eab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.5.0/token-x86_64-apple-darwin.tar.xz"
      sha256 "e7e1ae1c25e87a677f6578c46b7567c5f741db1b8822639a1a42d6a7839b8163"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/HelgeSverre/token/releases/download/v0.5.0/token-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f0eee894792f139b550c1cb924367dad8f3e0ab43f63044dfbe3e903f2fe9cc0"
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
