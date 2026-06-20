class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.1/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "01dafd14b1d6ef3e2be76d17a02c5a0bfb54c56411592848906ffb3bc0798f20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.1/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "dcaa622a1b76cedf595e68bf7c1d86525948bfd65f655ec49b59132ba9db5ce0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.1/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "061de40836f471c81a9a6d9ec1c1fcbbd4b57859a7f1eb6380373955939da619"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.5.1/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d07c57316127833e109cf4f8b359f2f55196d9c5b1e6898355ab6bb62673388"
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
