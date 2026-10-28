class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "831ca240939516915fd9080164bce26bb2a191558da869227c848d9e1c794f51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "9f419c67c2fdcd30974ebcbadfa58e6056e2b9a9172842d1f38e62e172c42117"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dff3b51b2f8a96782371988a06da74ab1f3130d437bef0003f39e9ddb4cafe56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v2.0.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "610364ccacde18de711baaa16cb5541d7141c96810fdac0575c87ad592b429c8"
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
