cask "helge-terminal" do
  version "0.2.2"
  sha256 "5aaa8ac2ade9886af2b94a80d1aac71dfab7308d594e6b02e2f52e68489efaf6"

  url "https://github.com/HelgeSverre/homebrew-tap/releases/download/helge-terminal-v#{version}/HelgeTerminal-#{version}-arm64.zip"
  name "Helge Terminal"
  desc "Native terminal with split panes, Obel Mono, and Metal rendering"
  homepage "https://github.com/HelgeSverre/terminal"

  livecheck do
    url "https://github.com/HelgeSverre/homebrew-tap/releases"
    regex(/^helge-terminal-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Helge Terminal.app"
end
