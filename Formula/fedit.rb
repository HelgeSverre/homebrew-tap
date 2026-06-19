class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "757f08f08f69e96307ff1fd3aa50836c98798ac8cf30697da452ca8bd4d1624e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "4ff83097a31b6d9731848228770b50f4932d5593229e241b0b5bf29a773a3f90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a6cee51b42b4707666bf1b9bf698acc20dd47c222059e832ddcaca7ade441ac3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "abed5edbabf97379a49c335eedd13ee4473d015ce5e89bab6fe5528958107c2a"
    end
  end
  license "MIT"

  def install
    libexec.install "fedit"
    # The out-of-process plugin host must sit beside the editor — fedit spawns
    # it to load plugins. Without it, plugins silently fail to load.
    libexec.install "Fedit.PluginHost" if File.exist?("Fedit.PluginHost")
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
