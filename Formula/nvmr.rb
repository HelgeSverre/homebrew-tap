class Nvmr < Formula
  desc "Native drop-in replacement for nvm"
  homepage "https://github.com/HelgeSverre/nvmr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.2/nvmr-darwin-aarch64.tar.gz"
      sha256 "abcb740048fe49538a24f491e9c6abb267da4dc2d5e58ac2a7c160bcd0b397a0"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.2/nvmr-darwin-x86_64.tar.gz"
      sha256 "5d8b91d58fd3e4f1252db03856e16b82f443768ab516f2c0d25c8d92bf801957"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.2/nvmr-linux-aarch64.tar.gz"
      sha256 "632791bb3990b507d2844589132e0d248bc977a2b3d4ff4a6c5a5aabb26cab04"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.2/nvmr-linux-x86_64.tar.gz"
      sha256 "8e7d9d00bbfc1740cf7641e045ff2db4ab1df9a39359267e77bc2a5a48452e12"
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
