class SemaDocs < Formula
  desc "Canonical structured documentation for Sema builtins/special forms; powers LSP hover/completion and REPL apropos"
  version "1.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.17.0/sema-docs-aarch64-apple-darwin.tar.xz"
      sha256 "f73d253fb399919fe006c04d39f714d6c330a5f2d96454180864306e5cad7c88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.17.0/sema-docs-x86_64-apple-darwin.tar.xz"
      sha256 "f31732f1f640c6a59aeaa43a0700d27f77a48924d6cb14fecf478db8b9539723"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.17.0/sema-docs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3537ceedbd0fe1d4a2f5df29fa34a1a7adda9ebb49820e3fee54cfdae814b3a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.17.0/sema-docs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2128ad014691e125fd90a0c52a7d6a64635d2d34d6f30436b5a5ac4615e2b08"
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
