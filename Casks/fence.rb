cask "fence" do
  version "0.4.2"
  sha256 arm:   "36b4f7b3f2750775e21102462c0302c0cdeb34b6a0fc7c215e0f2f1d1dab8c05",
         intel: "81fec65028979afa1fed3af4c9d734571265c4b8b641daf1391526fa09daa551"

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
