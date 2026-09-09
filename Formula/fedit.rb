class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "071dd110deab6eb0ea73564b5c1c1947aeea59074124c649d248021ec7fd0448"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "5758c5b075a653c17ac98ad3f76f96e1b43af9fd24f1f3656177e34cf61ded3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb1274eb49d35a14982d6f9be2068bbfaddb9c2352bca23eb6a66079cbddb366"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edbeabca8f631cb8d0d48d7944201249c1677d07d0d47c97b4cbbc702ac35a2a"
    end
  end
  license "MIT"

  def install
    # Install the whole bundle into libexec, layout-agnostic. The default (AOT)
    # build keeps tree-sitter natives loose in the root alongside runtimes/, and
    # the out-of-process plugin host (Fedit.PluginHost) + Fedit.PluginApi.dll
    # must sit beside `fedit` (it spawns the host and builds plugins against the
    # dll). Cherry-picking would miss the loose grammars; grab everything.
    doc.install "README.md" if File.exist?("README.md")
    doc.install "LICENSE" if File.exist?("LICENSE")
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"fedit"
    generate_completions_from_executable(
      bin/"fedit", "completions",
      shell_parameter_format: :none,
      shells:                 [:bash, :zsh, :fish]
    )
  end

  test do
    # fedit is a TUI; we can't run it interactively under `brew test`.
    # Verify the binary installed and emits a completion script.
    assert_predicate bin/"fedit", :executable?
    assert_match "_fedit", shell_output("#{bin}/fedit completions bash")
  end
end
