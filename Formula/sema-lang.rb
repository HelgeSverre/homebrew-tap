class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.29.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "37b16cb0dd03812e053daaa9d7fdb9b6393335244ebfd2c2281b833bad978470"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.29.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "c437680366f6c6d30f092772b4d18a5f688895cee74236c84026e965e5be8c6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.29.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d14b2258d0caa707b2aa05f13e46cf5188ce84f5f2d270aa632317eb2a8d2b47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.29.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18be1e98a90f3247e6e2420462bf61049d762ac1b2cc9ed54dd3ef5fd43e8aa3"
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
