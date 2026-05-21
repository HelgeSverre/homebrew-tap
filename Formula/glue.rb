class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.2/glue-macos-arm64.tar.gz"
      sha256 "3f9778226e431ae3cf41f4a9a28905229b27231b8a568e6dbb3e78d95af99cbf"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.2/glue-linux-x64.tar.gz"
      sha256 "4fd907014251a683e719e97f933a175322883916fe39d638f6879e95fcecd287"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.2/glue-linux-arm64.tar.gz"
      sha256 "77b064ef7e4cfec2c6ad722a994c474e871d04577cbfcf0330725454136e7da9"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
