cask "helge-terminal" do
  version "0.3.0"
  sha256 "73aed7d0081d9f349052f31b618b6a2adfd4fc51a4e7179be598dbcdc62ec033"
  url "https://github.com/HelgeSverre/terminal/releases/download/v0.3.0/HelgeTerminal-0.3.0-arm64.zip"
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
