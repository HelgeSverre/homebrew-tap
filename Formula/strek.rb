class Strek < Formula
  desc "Native vector editor for logos and icons"
  homepage "https://github.com/HelgeSverre/strek"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.4/strek-aarch64-apple-darwin.tar.xz"
      sha256 "3389a7b127851ed9e3e053ceef3d0d2dfea527222f0412f76aa520a5fc296bc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.4/strek-x86_64-apple-darwin.tar.xz"
      sha256 "5a5beba1a28406f37051ae472a61260dd7446a932327c98fa82aa9fbc62b0c17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.4/strek-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e04211d0790c42f4d4f64e9cc2865ac2b8fc08cd707f66d61a83de2ac8fc3ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.4/strek-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8af0dbf4f043ebf14e787bb5d2cb77bdd03cc9440a2d60c1ea4ff7f72d20fe3e"
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
      bin.install "strek"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "strek"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "strek"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "strek"
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
