class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.35.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.35.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "7d14f057f1d4b45aca9e74f5bb402252aaa9423c00541fc920dfa5fe959cd64d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.35.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "37890f86a065e9957363b0ce69a4f7468d8842ff2506f9c3a5f2f3189aab9ca1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.35.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f033e820d8812622e947ecbc18537387e3c1223391ae3250456f84520d1e613"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.35.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14f4be5210037a597bb8012fa6c57ce5f03645b2411ad89ee620915ee337a3c6"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sema"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sema"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sema"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sema"
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
