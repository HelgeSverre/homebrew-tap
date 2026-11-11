cask "helge-terminal" do
  version "0.3.1"
  sha256 "c8bb291b6d2950ce66b3785322a95a22f978102abb2364be798244d31138cce5"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.3.1/HelgeTerminal-0.3.1-arm64.zip"
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
