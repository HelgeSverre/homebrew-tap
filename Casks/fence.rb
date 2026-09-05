cask "fence" do
  version "0.1.6"
  sha256 arm:   "6a97b2f58b1c955ecb81d97a5192d69eab01d611e9b69ddf0195dd66f8f4e1fc",
         intel: "a65bb9ec18f264a3b98c88a5cd27cf14df145568323bde851d2680df121c2435"

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
