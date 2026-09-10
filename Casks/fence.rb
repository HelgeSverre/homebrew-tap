cask "fence" do
  version "0.4.1"
  sha256 arm:   "cbffd32e7ab37037e5982ef64a686e7415606e71dd0aaec0ff78e6fd4adb6fca",
         intel: "4d5e1c40389350bf0aa9a24fd7295e38690740df776283aa2f4a452df817e4a9"

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
