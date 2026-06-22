class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.0/glue-macos-arm64.tar.gz"
      sha256 "a56a2eb64adc6984864c51df09aea144337ee38c2879e4c38f209cb3f55ed25a"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.0/glue-linux-x64.tar.gz"
      sha256 "08982ec38687ef013ada9512c240a0ee37b33d1f52233b0a6a86aaacd4d66631"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.0/glue-linux-arm64.tar.gz"
      sha256 "1eac5f527245f28b4fea924d9c7fc135a11ef358f9a7e52d05363d74842cc7fb"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
