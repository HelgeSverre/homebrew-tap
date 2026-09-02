cask "fence" do
  version "0.1.2"
  sha256 arm:   "2fda3130f10416fbd10c9033e114054bc5339a1ea17af1c286aa33cdcceb16fd",
         intel: "37621904f0346b15cc852beb15c3b7d1346f11e8fd87657e1ad86afad53daab3"

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

  depends_on macos: :big_sur

  app "Fence.app"

  zap trash: [
    "~/Library/Application Support/Fence",
    "~/Library/Preferences/no.helgesverre.fence.plist",
  ]
end
