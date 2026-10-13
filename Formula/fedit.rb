class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.2/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "4959db61a33ab13bc692ab8d6807bb75581e03c3058e622a6ccb11569cec4446"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.2/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "1e2903ae7948bc73a64b0ab1c774add1e54c21eae3c2abf155ef6d4dee8dc341"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.2/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "114b39add773b09866bf63b8620eb7b4e137d95b1ad41a7cccd1d70c1250f57c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.10.2/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c032bd49eed424ae2f352bd781b8c2ea1bad07369fabe1d86e593ff1e1f26cd"
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
