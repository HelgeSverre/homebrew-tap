class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.20.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.20.1/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "b32d7f84498831a925bb030bd34aa9dd905958d63a906b32ff7d4c1a95248f21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.20.1/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "6b2b914bae72646150c2d33166896d70ca4730980370bf762f63534823ce9441"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.20.1/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "428d9562a0dbe5b435de38af514e15ba3e17ae448907baa3640ccb954ceb01e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.20.1/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1085b3b6d52bbb4626ae95aba271586408886965f28c5027a65f995c4824f4c7"
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
