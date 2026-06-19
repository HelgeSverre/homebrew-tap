class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.4.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "0efb7a46cfd704f77d9f46f89df543af61fb8fc28acd26c992fe4d4fd1d1ab23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.4.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "32bb688f07d9f8854686dfa561f30f73445b765e6fcd6626cbb873c03c707eed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.4.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eece65c23a9b3c0ea80d3105bbb20394260c1d579d4815ba7b452f02b7489e7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.4.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "27fd2a7491396fffa5ab3fc1bcb069d07c8e5fcfef6d2fc29f14446cac8b262e"
    end
  end
  license "MIT"

  def install
    libexec.install "fedit"
    libexec.install "Fedit.PluginApi.dll" if File.exist?("Fedit.PluginApi.dll")
    libexec.install "runtimes" if Dir.exist?("runtimes")
    bin.write_exec_script libexec/"fedit"
    generate_completions_from_executable(
      bin/"fedit", "completions",
      shell_parameter_format: :none,
      shells:                 [:bash, :zsh, :fish]
    )
    doc.install "README.md" if File.exist?("README.md")
    doc.install "LICENSE" if File.exist?("LICENSE")
  end

  test do
    # fedit is a TUI; we can't run it interactively under `brew test`.
    # Verify the binary installed and emits a completion script.
    assert_predicate bin/"fedit", :executable?
    assert_match "_fedit", shell_output("#{bin}/fedit completions bash")
  end
end
