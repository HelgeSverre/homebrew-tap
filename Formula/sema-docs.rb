class SemaDocs < Formula
  desc "Canonical structured documentation for Sema builtins/special forms; powers LSP hover/completion and REPL apropos"
  version "1.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.18.0/sema-docs-aarch64-apple-darwin.tar.xz"
      sha256 "563b7bde176d4728eba14d92eab2a737e0c023fbf59d67b176367c37f8cc679d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.18.0/sema-docs-x86_64-apple-darwin.tar.xz"
      sha256 "76c81b6422766522ae95e0c0a8a8920b05d158292ce5f6af837088fe02dd077b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.18.0/sema-docs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "895369400c5cda1bb529ee047a6e09b54a8771d2e34c51171d8f0f5f7f5fbd81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.18.0/sema-docs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87f99dc9e92db465c666f8cd46758c9c9aba4508cac66d0a88f082ccf0ea82ce"
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
    bin.install "sema-docs" if OS.mac? && Hardware::CPU.arm?
    bin.install "sema-docs" if OS.mac? && Hardware::CPU.intel?
    bin.install "sema-docs" if OS.linux? && Hardware::CPU.arm?
    bin.install "sema-docs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
