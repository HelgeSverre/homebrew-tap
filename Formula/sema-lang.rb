class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "2.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.1/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "ad824f743cee6e7576274cce7da3ef0e2c2ed6161554d7e9d3926c52ccf3850f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.1/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "bbf5faea35250e2d830f224fc83acbb1f7ba58ccbfcbfe397d5579f1cd6b88bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.1/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ee48904291ec097acab2b290d98d5459ef7bde75814221aad60534de5a46d5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.1/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31cb082100dcbad386179c8c1af570acc1876c0ef14bfc639847290265bdc117"
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
