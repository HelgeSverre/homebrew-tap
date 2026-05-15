class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.13.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.6/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "b0181946a881040033ee5404fd1235be8195a4a6d80045849e15a9272034f411"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.6/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "2e653080ab921872fffb99774127ffef9157bc20cac435ea170cb37edb3927bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.6/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd5b60923bfd114656b5c836e3a25fa2847e5d197d3489a12dbdeba816986505"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.6/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8009ea0c76c425bdae628ef628df239dfa8e6401910585aa3e8793634e632a5f"
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
