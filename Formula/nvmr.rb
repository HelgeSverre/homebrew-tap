class Nvmr < Formula
  desc "Native drop-in replacement for nvm"
  homepage "https://github.com/HelgeSverre/nvmr"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.0/nvmr-darwin-aarch64.tar.gz"
      sha256 "77598f991b0d988dba4213e9582efe94d62a8e12d1ef7afa278672f3fa58ab5b"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.0/nvmr-darwin-x86_64.tar.gz"
      sha256 "ea25e21d92bb1bd90da7dacda6e6b00d4cc5a529613544173e6c8a5dd9326c0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.0/nvmr-linux-aarch64.tar.gz"
      sha256 "411f8eb02825c5a67eeff74e5156da18b3f5b6040caa8d1fc090d719f0975c3e"
    end
    on_intel do
      url "https://github.com/HelgeSverre/nvmr/releases/download/v0.1.0/nvmr-linux-x86_64.tar.gz"
      sha256 "564a9a2a44a1be0f8329c6f2361fe731b36c1a8cff89ff1e0500c4abbdefc69c"
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
