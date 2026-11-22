cask "helge-terminal" do
  version "0.6.4"
  sha256 "3ead21b942826dd9dae4e98b83b5dc6cc4b5c33c628ec54a0dbd5f5dfb9f9dd5"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.6.4/HelgeTerminal-0.6.4-universal.zip"
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
