class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.1/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "8606fa74c5832c3b52540fcb6afe888027beade34924c058041a364a3a9bee04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.1/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "744ce07b186261ec74fd09bada85861ca17ee28674f090e5078e0c3aa35913c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.1/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05266bdef9072680ce74b72e2a05509dcfbc63bd6943595d4866dfc6ed72f990"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.1.1/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2e38932051260a2869b56d0ef3a729f4bea7eff0f5fad9ed75b399ba726a11fd"
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
