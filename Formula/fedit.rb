class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.6.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "c9971524b2d6b121f719c2d225a1319d7ff61b88746e3403529b578698260669"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.6.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "4e947392c0f11f17d5c73643d017133518fcf216ff201712718fcbfbec4aedbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.6.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43b6cda67456b39df10737c6dca7fdde9c54722e6791f1ea3109bc0a3ff8a948"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.6.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "79527024965d279afb34fe5fcc474f2e00424263a4c597f2a6927cdcbd4a59c4"
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
