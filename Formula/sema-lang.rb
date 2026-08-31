class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.36.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "3f97176aec974997efff8f27fa706ac3b49eb720e1b2ea7ed5ff01932f8779c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "0900b4501118eeb668251e9e797798363f3927be4928385e58db2ea71266838a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc1abfe4ac589bcc551aedc10dc7f9781e2b9188a2481896b7759000c20ebf65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sema-lisp/sema/releases/download/v1.36.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a70d7ef0b0904ea4b2c369cb487d2ad88bc25d357a0994038f3f4cd16017932"
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
