class Nvmr < Formula
  desc "Native drop-in replacement for nvm"
  homepage "https://github.com/HelgeSverre/nvmr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.3/nvmr-darwin-aarch64.tar.gz"
      sha256 "5d36daf9385991a1f34120991cdc3930547035d69a6270a944e39f84b53432ce"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.3/nvmr-darwin-x86_64.tar.gz"
      sha256 "5adb4320a01b74419a4aec53e54bb5e99596be08c59d4b68224e35cc13c42259"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.3/nvmr-linux-aarch64.tar.gz"
      sha256 "ec1bce26894174328bcb4d026e8d684b44ee0b81f6bbdba388d6247c6fb38131"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.3/nvmr-linux-x86_64.tar.gz"
      sha256 "4da7a192b7e0078382b0e7b0c2bd37aec37e03ff783955a2a5450fd9f2bf54ce"
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
