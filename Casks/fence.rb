cask "fence" do
  version "0.2.0"
  sha256 arm:   "ca209f1e72cd298f55c9498e5ddeee1f0ea0534ac1a6836c0836495fa0b01d45",
         intel: "dd2c41ada61db4bfa87bbd3978bdcba678ea07930b3d2a9f8e38fa3f1cf99235"

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
