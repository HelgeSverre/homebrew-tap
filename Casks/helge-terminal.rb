cask "helge-terminal" do
  version "0.2.3"
  sha256 "9b37bbbb812846a141e83d31b5666f291131145eed1b5c1b90fcca3fc21a5ee0"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.2.3/HelgeTerminal-0.2.3-arm64.zip"
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
