cask "fence" do
  version "0.1.3"
  sha256 arm:   "48576b9539a830a5704cbc77c76ebc4cbc35a70e970f7669d283235ad1bc8fae",
         intel: "af3e63c385b82c16e7c12b3d56258f510f42e9c0af453f61a1a21bb33b2ec3be"

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
