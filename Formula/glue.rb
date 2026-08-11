class Glue < Formula
  desc "Terminal-native coding agent"
  homepage "https://getglue.dev"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.0/glue-macos-arm64.tar.gz"
      sha256 "53175e0a93e6e93e59aa34ce3aca4e0a6d7227d0e6657f257b60d0937f235441"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.0/glue-linux-x64.tar.gz"
      sha256 "8f34eb953ad2897126887fa88804160f34670c9b0f92ccbb8aeae39ba093c33f"
    end
    on_arm do
      url "https://github.com/HelgeSverre/glue/releases/download/v0.9.0/glue-linux-arm64.tar.gz"
      sha256 "24ded2fde2cf069859544db789a7580d4838fcb8fb2b396b1086928eaf076c35"
    end
  end

  def install
    bin.install "glue"
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/glue --version"))
  end
end
