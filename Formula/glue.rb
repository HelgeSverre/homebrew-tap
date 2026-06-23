class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.1/glue-macos-arm64.tar.gz"
      sha256 "ca04e7680ab8c90845d7b320b17b1e626df4aacc3de9d9149c40fe69c6d885da"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.1/glue-linux-x64.tar.gz"
      sha256 "147b0025571343bf4dd64c31dbd71d3e9eb2f1a0188cb18d35d47d0ac6bc031c"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.7.1/glue-linux-arm64.tar.gz"
      sha256 "af274fff6c5ed60d2aa9097220de56ec23b51953dcc1ec14e710059695eabcfa"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
