class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.1/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "4000ebbfe90b7fc8cb6d229e681eb3cc65c6b203402322a421429f01c9923135"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.1/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "d83ff62dce6b0ab63fdbf12c5c4dde4eeac8f08ae1808f165c6c0f5122ede484"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.1/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8cd072f18dde07552f0b3332c46dca377d6f5ae2a501229f2fe511e88f01e24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.1/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4abebcebedcc3118420449a39b1020511e1a01bd1124db2c56efdd590c4b832"
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
