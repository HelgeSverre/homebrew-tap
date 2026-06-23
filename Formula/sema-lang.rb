class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.26.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.26.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "701b49985acc0700b5566bbfbcc6905e0b75696c767e6f536ae27f7fe3db2c01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.26.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "530a278658ce6b00ebbd8485fd19632b9ebe3e1d664c5cda3b92cdb22c50e04c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.26.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee44839a18623663bdbd1dea035cfeed4d561f78cc6c0abfbca57b82d14ac2b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.26.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2338283f90a40ee1332fa40df8b207d4df6345ce5ab7afbc66ccdacd0ac2f30a"
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
