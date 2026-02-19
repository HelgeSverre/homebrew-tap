class Token < Formula
  desc "A fast, minimal multi-cursor text editor with syntax highlighting"
  homepage "https://token-editor.com"
  version "0.3.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.19/token-aarch64-apple-darwin.tar.xz"
      sha256 "5ef96f6259b249c5f28b2745c6523d45af9bcc776f30b77377cbffdcefe58cae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.19/token-x86_64-apple-darwin.tar.xz"
      sha256 "b4b26b3ec538d519c0232c7b22545ec60f9538bb17532368e022d1513b9fa8b4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/token/releases/download/v0.3.19/token-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a373666876422f97c2cd4f17f5f204650719481b4069652f4a451014cfe32406"
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
