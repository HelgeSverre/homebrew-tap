cask "helge-terminal" do
  version "0.4.0"
  sha256 "37ecd9c5c53f44116b2efed9d630a47e846be30beaf305448fa528cb90893a05"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.4.0/HelgeTerminal-0.4.0-arm64.zip"
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

  zap trash: [
    "~/Library/Caches/no.helgesverre.terminal",
    "~/Library/HTTPStorages/no.helgesverre.terminal",
    "~/Library/Preferences/no.helgesverre.terminal.plist",
    "~/Library/Saved Application State/no.helgesverre.terminal.savedState",
  ]
end
