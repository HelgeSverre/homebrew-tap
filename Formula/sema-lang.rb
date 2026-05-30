class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.16.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "38131ec747c2c4fd7da40b42bc4701a60f378a0b3b3c747e0b098744077028ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.16.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "44d5ed2692bbf4e5cca3dbae606191a1d070514a709fb70bce4c12dd552aaceb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.16.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25e2343df9f273854f97675e2014adcb696ce48945f15ec943588cd4e141904b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.16.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a86d319ba213aa21a663dc9fbe5d87c55a30164622263179e4991cf0895a1918"
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
