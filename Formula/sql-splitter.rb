class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.16.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.16.1/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "c252c4082e50cfcca6d378664411d65aa236491b094b287b4eb8eeaafa81031e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.16.1/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "f0b1acdc6835f3d925f24eaea06abf5ef96138c06c75828f50d0fb15deaef9fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.16.1/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "638fe8669d4837556227a3dbae5d70f3f8b984a295706cf1bf3830dbad9e4573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.16.1/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c83657d0c800596d59684f9b69a1baddb96ee97d8879e2c47ff9c8c50867fabe"
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
