class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "94284375b4176de1e5ba5780fff972b1a978c05e67b27f58a6b27674de5938cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "b946bf22508b586cb3a1aea66ee429b8fc4fbf48255a83dec0c4bcd0a8e27043"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "007906d989bf4ccfd01b3ceb5ea9ad77bd6c6559c077cd3bdd283b111d3d747a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c22ce14695e1ee482266a5d6bad412eca728d12656115858f8d7cc8d099b2e00"
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
