cask "helge-terminal" do
  version "0.6.2"
  sha256 "114d3ca8e114de39b9208759e0d016968ac145aaf1f1e8a859aa7824179fab91"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.6.2/HelgeTerminal-0.6.2-universal.zip"
  name "Helge Terminal"
  desc "Native terminal with split panes, Obel Mono, and Metal rendering"
  homepage "https://github.com/HelgeSverre/terminal"

  livecheck do
    url "https://github.com/HelgeSverre/terminal/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on macos: :sonoma

  app "Helge Terminal.app"

  zap trash: [
    "~/Library/Caches/no.helgesverre.terminal",
    "~/Library/HTTPStorages/no.helgesverre.terminal",
    "~/Library/Preferences/no.helgesverre.terminal.plist",
    "~/Library/Saved Application State/no.helgesverre.terminal.savedState",
  ]
end
