class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.10.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "bf29c71eff8b8e0dd9bcb50455c61b80dab84b0de3ac0283b152f1b715c4e2bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.10.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "e858e0fb320bfd78fae6263c495c63ecb08d861d13bf187e7c67bd753b0ebcd5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.10.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "90bba2a0e043471b5ba62356679b5cae7bbc3bd45eff4eac9a16e6b640875dd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.10.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37f64c3a8355761ad836e8432143b4aae0c340de9cb8dc505dfba23558834e27"
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
