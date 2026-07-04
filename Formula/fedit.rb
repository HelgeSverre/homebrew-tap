class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.3/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "8abfe6932f6c87c522ff028aab9241a5a72324ab901464cbcac722eb01f672f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.3/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "b6bdd0aa135209cc2fa052ab5aa42d3540fd5f04cbbe85d17d8f4e63694d011d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.3/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1f1b3668f66f95390c4ee1d258d3965333c9a6b75c6bc5b3cea41ebd252448b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.3/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "711455462346fd1a2c66e4c460b6373ab370ca8b638599cac7cc6b1e57e1c461"
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
