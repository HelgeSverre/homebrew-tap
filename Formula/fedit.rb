class Fedit < Formula
  desc "A small terminal text editor written in F#"
  homepage "https://github.com/HelgeSverre/fedit"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.3.0/fedit-aarch64-apple-darwin.tar.xz"
      sha256 "1262176c58b4c5325b489439f03fac498ba037dd9210c0ba3b42c8dff3b6fffb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.3.0/fedit-x86_64-apple-darwin.tar.xz"
      sha256 "dd6fa21c76e1ac3a80c6523a1418f2fef0257902b710ff344bd5be69c2a78b5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.3.0/fedit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e05d9bc39cda988d9844b50847bf640c0e123c25d85b93a0a62bd1f6c1f00775"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HelgeSverre/fedit/releases/download/v1.3.0/fedit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a4f3c2c783e31c7cede03492fe0daa3140e89d14a90d150842335a13e10ca839"
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
