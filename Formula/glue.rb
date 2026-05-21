class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.6.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.3/glue-macos-arm64.tar.gz"
      sha256 "c8bc2e7123a8e9d3ed421f54f186dc4fd23f9be9224efbfa640f5f3cc3fcb253"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.3/glue-linux-x64.tar.gz"
      sha256 "cfb71ac6ac5711c035278d486b86ff3d8cf63e70dfc8c6adcecd239574f030a0"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.6.3/glue-linux-arm64.tar.gz"
      sha256 "f65b674e275ae42cd8904c58ceebb883b0f11c50b15c42a6f7abb00ebd9b25eb"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
