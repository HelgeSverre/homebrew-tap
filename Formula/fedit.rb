class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "0.0.1-test"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v0.0.1-test/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "34cdb19c8374428a80278f25cd70edd8e2db0e126e1bd6a7c357e04155e9ee2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v0.0.1-test/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "6644d4524442d7c171b9df8f1b7516763a04d61523e1ee5b58f5559a2f2b2c65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v0.0.1-test/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9e1ad7c2fd9dbc7ad095587c2da5a89bd6cbfdd018cba88393e2bb660c0ed61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v0.0.1-test/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96a47dbb6f351d674779142e0ecc1c753bf1de1983428866a50f37c5d70aea82"
    end
  end
  license "MIT"

  def install
    bin.install "fedit"
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover = Dir["*"] - doc_files
    pkgshare.install(*leftover) unless leftover.empty?
  end

  test do
    # fedit is a TUI; we can't run it interactively under `brew test`.
    # Verify the binary installed and is executable.
    assert_predicate bin/"fedit", :executable?
  end
end
