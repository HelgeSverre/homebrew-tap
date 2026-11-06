class Nvmr < Formula
  desc "Native drop-in replacement for nvm"
  homepage "https://github.com/HelgeSverre/nvmr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.1/nvmr-darwin-aarch64.tar.gz"
      sha256 "5920233fc84cacede7f0dc23735790c67cc85138a2351f0c387e8d43b4cdab93"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.1/nvmr-darwin-x86_64.tar.gz"
      sha256 "fb62c1ed08ee47b1978847564ecd67c51367c57f3522846563bde4c9ebfee0c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.1/nvmr-linux-aarch64.tar.gz"
      sha256 "f612a409c39ed4c07d6ea50e94f91cce25e78d4e79344e10b3f9fe35cc517174"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.1/nvmr-linux-x86_64.tar.gz"
      sha256 "724c74146ccbeb90a484c2cf255e6ddf1da3c74fac6d0d6cc80fc09a1cb7f945"
    end
  end

  def install
    bin.install "nvmr", "nvmr-fetch", "nvm-exec"
    pkgshare.install "nvm.sh", "nvm.fish", "bash_completion"
  end

  def caveats
    <<~EOS
      nvmr provides the nvm shell function. Add this to your zsh or bash profile:
        export NVM_DIR="$HOME/.nvm"
        export NVMR_EXE="#{opt_prefix}/bin/nvmr"
        . "#{opt_prefix}/share/nvmr/nvm.sh"

      For fish, add to ~/.config/fish/config.fish:
        set -gx NVM_DIR $HOME/.nvm
        set -gx NVMR_EXE #{opt_prefix}/bin/nvmr
        source #{opt_prefix}/share/nvmr/nvm.fish
    EOS
  end

  test do
    assert_match "0.40.8", shell_output("#{bin}/nvmr --version")
  end
end
