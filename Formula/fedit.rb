class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.8.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "f457d2516643a54e9d33c63e7ccd5263f764ac890d24ace497128286a75f0e4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.8.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "e85b42bba91a4fd88c6ed54cd2b1aef7ad78c1b7f78b20b73295e5bde70f91ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.8.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a721b40e9a0cd0fa36bdc5050c6947d159adb723d60c4d3393c978aa0ebf85f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.8.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fe16703d4c093028af59360a4f4fbb27e8292292d76ab51467a122b94cec883e"
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
