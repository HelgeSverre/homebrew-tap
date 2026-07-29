class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.33.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.33.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "bb99fd063a3f3ff84a3c6666127cc095be2db6142daf0b7b89e6a71c4a035c81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.33.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "1d7899a1ea5c3b9d3c29451c2e09327b1d33a4ee2b53c48d1e35c2aaf798d26d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.33.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f41791eb26f8a0b4742fc4c43ac1aa2eee169038b1f263aba2f49a6904a73713"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.33.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7f456e796c2c5c8e385514773c7225fc51537161b51aa3b5aa6b8d266194068"
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
