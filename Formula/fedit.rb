class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.2/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "4de899e574fd219256ad040479783096d129a5e06feb1ce87d83c373a6e2b4ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.2/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "a176560493ba68765fa4479a7e7d177d5751c4e0f12c517fb5c1dfa206ee3ec0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.2/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b79588254c9a2faeee398144e7af938f4201028a2437b3a34889d3c68e411df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.7.2/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0a76a63b2be9d859054e46e633c12ab89c8d71f9f06c0ea8fab9baef42946c7a"
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
