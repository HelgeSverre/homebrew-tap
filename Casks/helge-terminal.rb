cask "helge-terminal" do
  version "0.4.3"
  sha256 "9b105733ff03a3cfda7d3790fa3067cbf5b9ea7c4e8ea6703650bbead7d4f8e7"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.4.3/HelgeTerminal-0.4.3-arm64.zip"
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
