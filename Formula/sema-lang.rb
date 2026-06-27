class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.28.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.28.1/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "d9d12436820b8a624835fe3f15349662bae8489cd37ccd65ae4e7c81d02294db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.28.1/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "2186c84b5c4ecbc205e763481a1f45139932904b6d4ebaab216664cbc3173da5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.28.1/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb40a57281196b19b5c760fccd84d02f4abdffdc988dfaf2d10c483eef26331b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.28.1/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60b15f043423e3867f6ec1c1a01edc6949e9fb83329164946654998d34661d06"
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
