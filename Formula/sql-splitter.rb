class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.13.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.5/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "0ce04ae9f2a3d976c1f2ad6727557048046cf9d49c13a7a1412f5bac97656db9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.5/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "e670d2232739a487b3dd3a3ca30e5ba37dfeb02dca2732a6b6c42b3c2bec20bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.5/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3cb742396a9464ba970ff62f1ee603aa3aacecbe6fedb95ba7e37250fc1aad0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.5/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f00a664ede15f6a074e384508854b83cac2b5a6431b2c606299247c8fe1dbba"
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
    bin.install "sql-splitter" if OS.mac? && Hardware::CPU.arm?
    bin.install "sql-splitter" if OS.mac? && Hardware::CPU.intel?
    bin.install "sql-splitter" if OS.linux? && Hardware::CPU.arm?
    bin.install "sql-splitter" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
