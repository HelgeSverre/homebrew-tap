class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.7.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "345034ac5a2c952dda3cfc914188d40cdeb2fadb899f05b276d811afd272c24e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.7.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "9316a9fd972c8fdcee685cfb796ded5e7001b29d62ccbcb3fb6bac1a02c9885d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.7.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bddd666f42f8df77f35ac7ad54c740a6eb7cd244eb47ca9cbe42d0b015400f81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.7.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f90dbe1836dc7965a1890b93122aaa57ae6aafa749b44a62739b6947408d974"
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
