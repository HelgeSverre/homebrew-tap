class Strek < Formula
  desc "Native vector editor for logos and icons"
  homepage "https://github.com/HelgeSverre/strek"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.1/strek-aarch64-apple-darwin.tar.xz"
      sha256 "b574a8d98f91687f4085570a34dedd84019fe9a3a92ab66122b8eb07b4fac4db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.1/strek-x86_64-apple-darwin.tar.xz"
      sha256 "028e5af06cc4cca6f4b5181adde4936855bf31d15253567b5d26a4bad1679f6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.1/strek-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77f051044f5b977c06c2b3aa2ec18504eb6e2dbeb1892e24216a8d49110953a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/strek/releases/download/v0.2.1/strek-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9104b90618198bd7423c91456ae8cf42a51e380d3aa34fcab8d7a04cd8cb9721"
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
    bin.install "strek" if OS.mac? && Hardware::CPU.arm?
    bin.install "strek" if OS.mac? && Hardware::CPU.intel?
    bin.install "strek" if OS.linux? && Hardware::CPU.arm?
    bin.install "strek" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
