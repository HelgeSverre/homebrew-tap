cask "fence" do
  version "0.4.0"
  sha256 arm:   "ecd9f7153ee3b23950973d732ff89d17dc237a57df8a58971d3564356fc92943",
         intel: "9151ec8ad3c2aa806866ed0c481419b66f3c16a4f330f62bfb27e8072ad6040d"

  on_arm do
    url "https://github.com/HelgeSverre/fence/releases/download/v#{version}/Fence-#{version}-arm64.dmg"
  end
  on_intel do
    url "https://github.com/HelgeSverre/fence/releases/download/v#{version}/Fence-#{version}.dmg"
  end

  name "Fence"
  desc "Desktop Markdown editor with live preview, built with Elm and Electron"
  homepage "https://github.com/HelgeSverre/fence"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Fence.app"

  zap trash: [
    "~/Library/Application Support/Fence",
    "~/Library/Preferences/no.helgesverre.fence.plist",
  ]
end
