class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.8.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "f06943f198e39779cad937c7c13a08b72b05f57e2810a1229a604a84ee3dc7b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.8.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "e04864f7784476b01a30ae095c2426b6fc6c4e4495ad6bf7bf0329777abdf782"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.8.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b24796beae7f9608f1e52adf3b56e91578880a737daa2f369069db68a618c8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.8.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11e982fbb561eec86a75bf9d0ecf1b20f38fb2231f32c571a17b95aac600a02a"
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
    bin.install "sema" if OS.mac? && Hardware::CPU.arm?
    bin.install "sema" if OS.mac? && Hardware::CPU.intel?
    bin.install "sema" if OS.linux? && Hardware::CPU.arm?
    bin.install "sema" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
