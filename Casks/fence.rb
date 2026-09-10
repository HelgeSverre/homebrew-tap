cask "fence" do
  version "0.5.0"
  sha256 arm:   "3b8d49b8b804bd28c7224bd9b501095042a09c21eacb1be9ce47bf91d8040a53",
         intel: "923634f88e2ab97cf6a33c4072cd55eca18296a38dbb5e1442d9700c4165be97"

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
  command_wrapper "fence", executable: "#{appdir}/Fence.app/Contents/MacOS/Fence"

  zap trash: [
    "~/Library/Application Support/Fence",
    "~/Library/Preferences/no.helgesverre.fence.plist",
  ]
end
