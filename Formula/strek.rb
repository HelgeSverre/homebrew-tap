class Strek < Formula
  desc "Native vector editor for logos and icons"
  homepage "https://github.com/HelgeSverre/strek"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.0/strek-aarch64-apple-darwin.tar.xz"
      sha256 "91cd54e26433bb55f5fa588b0e0451d72351ecba5f897e4e485c8adfd214b9d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.0/strek-x86_64-apple-darwin.tar.xz"
      sha256 "aafadc5087ee03edbb51771a90a62d8768d72e841c38c537270c8fb9fe61bfe7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.0/strek-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "149f0a3c851a198199b10fec41c2f85007e72915bbb9db8c2309f485806f440f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.0/strek-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ced28079f7a0eba6731572c87fd7d111493ff0778a9561d6c67436f1ada1641c"
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
    bin.install "strek" if OS.mac? && Hardware::CPU.arm?
    bin.install "strek" if OS.mac? && Hardware::CPU.intel?
    bin.install "strek" if OS.linux? && Hardware::CPU.arm?
    bin.install "strek" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
