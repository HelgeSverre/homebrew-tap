class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.19.0/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "e71895c4584291d5fd5b0e4207ef5518d32b7b16c8156f2d17f30fecfe10a937"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.19.0/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "270b7cf2fd065f99e50eb4e8cc45ab9f4c7178126f1c681d0dcd18014aee332b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.19.0/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8f6b1928a02de5d377e25d3dab3a2e781d34e83a5ca567c705e57064d4c37c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.19.0/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cd8789602b299742637ba61482758b599aa98a0d35f8d5f6ad830865fa8c784"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "sql-splitter"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sql-splitter"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sql-splitter"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sql-splitter"
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
