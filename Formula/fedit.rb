class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "a91623eed32beaad70c6e61853b7c4ae9b18fa49e844a8028ef95e984478cac1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "0fd6653f2aad0d991e47237232787608797d35a0535206fdcac544020d883582"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13e8f4f384aa2c7e296e01f475de314ce35cf824e6c6c63e13f7790df4685f1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cc5217c1086547cc609d98b8dc43ce2eceb191bd1f8d2c9eb7694e458ee0e49d"
    end
  end
  license "MIT"

  def install
    bin.install "fedit"
    generate_completions_from_executable(
      bin/"fedit", "completions",
      shell_parameter_format: :none,
      shells:                 [:bash, :zsh, :fish]
    )
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover = Dir["*"] - doc_files
    pkgshare.install(*leftover) unless leftover.empty?
  end

  test do
    # fedit is a TUI; we can't run it interactively under `brew test`.
    # Verify the binary installed and emits a completion script.
    assert_predicate bin/"fedit", :executable?
    assert_match "_fedit", shell_output("#{bin}/fedit completions bash")
  end
end
