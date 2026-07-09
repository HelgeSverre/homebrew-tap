class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.8.0/glue-macos-arm64.tar.gz"
      sha256 "19336c888eabeb8217a8f8899da9db2f8eeed80f955763701068a66fe7119ddc"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.8.0/glue-linux-x64.tar.gz"
      sha256 "59ea0feb73f9cecd22417261f543386502e6ab9c497881023c955117af329978"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.8.0/glue-linux-arm64.tar.gz"
      sha256 "a4dca6cc3b1aaa41ae1ab4115fe9c85a716f76506113101f43216f61a661fc0d"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
