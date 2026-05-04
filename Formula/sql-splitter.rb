class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.13.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.4/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "9331bf8367853479241ca96c918b7ad1d6dacf11c9b593c6edf2aa29338f6f28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.4/sql-splitter-x86_64-apple-darwin.tar.xz"
      sha256 "e13f7dfa013e2106dbe3c71d216fb8c25756ffcae9f379678c14f3dcc2408efa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.4/sql-splitter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4971d0ac09bda85c3c5cca63cbfaec11c2699aad05ac6e713d541eec763da61b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sql-splitter/releases/download/v1.13.4/sql-splitter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aad1ff88bc07a2c367bc1d942e36f713d9ce6e42f1b01c7b7d6e71574762f394"
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
