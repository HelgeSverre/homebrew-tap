cask "helge-terminal" do
  version "0.2.4"
  sha256 "ce4cfcf7e61e22a787f3b70c19a90327eb032354ae39e8a9a8387dab5bf3bfdb"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.2.4/HelgeTerminal-0.2.4-arm64.zip"
  name "Helge Terminal"
  desc "Native terminal with split panes, Obel Mono, and Metal rendering"
  homepage "https://github.com/HelgeSverre/terminal"

  livecheck do
    url "https://github.com/HelgeSverre/terminal/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Helge Terminal.app"
end
