class Speak < Formula
  desc "Offline text-to-speech with the command-line surface of macOS say"
  homepage "https://github.com/HelgeSverre/speak"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/speak/releases/download/v0.1.0/speak-aarch64-apple-darwin.tar.xz"
      sha256 "5a35f7e585b85205c13611b249d5b89547b293a121045b5afc3eb69b0b8d7c02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/speak/releases/download/v0.1.0/speak-x86_64-apple-darwin.tar.xz"
      sha256 "7d9db7950bedab8bf496be8e0ac683ad1bbd7eec4adb7c889ec554e55a0c08cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/speak/releases/download/v0.1.0/speak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "264f2e2396fcef65c91e19e2c0073199cded9ea23f274cd46366bc02d0d28567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/speak/releases/download/v0.1.0/speak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "876efe0afaba5011fb32162fea5f3523cfae0d5b1d5cfb0e8e6537dce5a7f7ad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "speak", "speak-lab"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "speak", "speak-lab"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "speak", "speak-lab"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "speak", "speak-lab"
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
