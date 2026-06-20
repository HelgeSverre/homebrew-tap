class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "609eb0c10437802d8d9d94254663b931c661c439b227d5991aeb24f3286b93a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "b109de1229d0188b308ecb5dbd665ddd30c24a6836fb683a9d643ec861117005"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "78344a6fb5b706148a599983ae4a565fcd3670d28db9e64723439ced33ae1315"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60615aaed445b3f344ba102f1282a630de43b139127eff8eec72959ac3edcafb"
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
