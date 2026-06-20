class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.1/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "0c54aa83fc2bae65f1efc9d0003a27ac145a05441eeb62cfa9e4962cf6a8561f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.1/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "1ae65af4fefb2cffcd336618f2a1b452f821ff4fc07ffef43c388c1462068a1f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.1/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1f10d5eb811112a68c87c648afca4f2f4e0cd2b1bc51086043a8be3ace933dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.1/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "569b5956a5b6cc740e622abc3f7a3ea53ce46f46e696dfaac7f01c9f434af7ea"
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
