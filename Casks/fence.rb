cask "fence" do
  version "0.1.5"
  sha256 arm:   "f07dde35c8828056e845ed3caf9d3391005c148f2f7bcae4409501765d0de320",
         intel: "1e018c94e170f446f26330cd1c8c3b9c4d29884a55cc85d57f9b8f25d4f87e2a"

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
