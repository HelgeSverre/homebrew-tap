cask "fence" do
  version "0.1.4"
  sha256 arm:   "6cb0c0071f0954e1e868830787eb1b9341ba529a7354103baf6fb945c0dc299b",
         intel: "65b62d7be7d3c7e4a064a61d9bf3ab8c2f81c389689c8678cfc8da631b64a4cc"

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
