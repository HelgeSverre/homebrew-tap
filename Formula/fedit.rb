class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.2.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "dd6629536b0a7ac541f21593fe9801af6a891ae125d1c059665fc9a5d07dd5f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.2.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "2dd7ba545d4aff978f7a2d11ca379ee9d58a0404a0b5418c71247d2685637d6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.2.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d32544049b17ec2b3a61034afaa6c10ebfb239c8582adec9c8fab6df4f795136"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.2.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c432c1b108d2fcb3b922d934e763c9ea4a06451cea08ad65c00c5e79b25a773c"
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
