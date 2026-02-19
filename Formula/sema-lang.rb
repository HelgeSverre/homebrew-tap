class SemaLang < Formula
  desc "Sema — a Lisp dialect with first-class LLM primitives"
  homepage "https://sema-lang.com"
  version "1.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.9.0/sema-lang-aarch64-apple-darwin.tar.xz"
      sha256 "9e8b4999d373773f3a38a139002b5ee8abaafb949206439ec13f16dd1d08111c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.9.0/sema-lang-x86_64-apple-darwin.tar.xz"
      sha256 "b10ad2347bc4dae82c88a3330a7a64902821e1e17056067b3ec48dbe9a43cba0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/helgesverre/sema/releases/download/v1.9.0/sema-lang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "645f2ca7abf98e16a52fdd8c62aef0c1bb009b63c682dceffe801057bbeab20c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/helgesverre/sema/releases/download/v1.9.0/sema-lang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "baf859ba08f6d8e26c9ff670228ff5e0728f047a8c8771774f4f9fc7a5eff4d5"
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
