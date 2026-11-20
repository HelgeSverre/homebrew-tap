cask "helge-terminal" do
  version "0.6.3"
  sha256 "821e46a278eefc38fe5b5a1d0070981ec42fd3aa81cd761609bc7e9c99576b48"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.6.3/HelgeTerminal-0.6.3-universal.zip"
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
