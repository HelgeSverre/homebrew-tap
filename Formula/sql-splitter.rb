class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.18.0/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "313b8d13246d802801aced581c38fc938b620d2c83f58d85d27ce0059929d79b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.18.0/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "566f50c72709af0041e2f55ad852bcaba2c883b0d31c95ad6b34d615af98a7a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.18.0/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6856d0c1dbaf2c1324f81e25366a7e03eda5134988a073d297d045b580209e20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.18.0/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0c022c32be6f9856234b324e2513963b98cb2335885373fcc2f523049b6fe83"
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
