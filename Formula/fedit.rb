class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.1/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "94b2c95874a0238ce72fb58ddf4822c282ee1f48602cb3475a2bbaa690dd57cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.1/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "23cd874859ea01ce955ab3b1b199c3f95c9cd362d9bb29c35969b2b7e569242f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.1/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15e10f8857883736352494f2ed2a5cf4685fc3cbd30de124ecf09f8eda8b51a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.9.1/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "803dbb71fb1a85e74c5443aaa2889965c1a510174a389447b39edc00437956c4"
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
