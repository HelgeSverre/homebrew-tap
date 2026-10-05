class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.36.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.1/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "595b3f0d8e99e2a994d87c944f568eb6ad4739e64d3714ba26363015b92a5c8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.1/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "e0b1ec487d4e5636117560ca88688c8193998f0ea7e461ca93fb4c5ae46ee5a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.1/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ade7dde9bf00d4dafa3db1dadb1abb40723297347e0aeb55fc03f19a8f32d6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.1/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8adf31e1cc401339ff534b687e68a0608ec60a2f7f85f50b6f17bff83c7f9808"
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
