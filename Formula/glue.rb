class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.1/glue-macos-arm64.tar.gz"
      sha256 "4d80157465af5c5126e51b14419036a5f6c9bf3c6d8faeebcbc2439ab2895535"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.1/glue-linux-x64.tar.gz"
      sha256 "a337092ef4025da5ee55ac240ef99161e84a7041f76f704c761eb75a98debebb"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.1/glue-linux-arm64.tar.gz"
      sha256 "b03077636f9222f4ff73e3d4dcf192b62b3e2a5cd4d5afe7aad28e91bd675580"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
