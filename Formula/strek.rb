class Strek < Formula
  desc "Native vector editor for logos and icons"
  homepage "https://github.com/HelgeSverre/strek"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.3/strek-aarch64-apple-darwin.tar.xz"
      sha256 "a46f70067b115797e912e3f4cd653e71e9a9df46da2ea06d631f874b1e9b3d12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.3/strek-x86_64-apple-darwin.tar.xz"
      sha256 "9b6eb2dae351f46f73fc954f67ac8183de868fa83c2b020fb83eff49bcd4ae04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.3/strek-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0846530288b42d61ccac68e270c0f3beadd5a2b3421064586a53f6ce1093ffc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.3/strek-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62b058eaf4eccaa26239ab8928ce23bdec6ee3e51132e2301ad99f1199ba73ba"
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
