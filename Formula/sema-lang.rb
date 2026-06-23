class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.27.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "17af57e7f846fa27f9b5c1b73a85f2ab2c139d91bdd9c235a8edf4560ae7d0b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.27.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "8f6c1d8cf390a96c0b80c006aeb2241d9d7c61d3aabd40ec4bea82ffcb16c293"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.27.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f04b2fe4c474d3f801bfece52038312a6f3b79a3c90cddc1e9f995769a6c6f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/sema/releases/download/v1.27.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e252f67d7e9f35e6eeddb7dbf1e23146af842fc122eb88d656fbf754decc91a"
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
