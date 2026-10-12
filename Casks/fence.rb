cask "fence" do
  version "0.7.0"
  sha256 arm:   "8dc6175f09d6df1adc461b84f565aac560a026d574389879547074a3b225e81c",
         intel: "e04afc4a651785ac9c140c190926417ea0415c25a97e054d000f25d97b73360f"

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
  # Detach so `fence PATH` returns the terminal; help/version stay in the foreground to print.
  command_wrapper "fence", content: <<~SH
    #!/bin/sh
    exe="#{appdir}/Fence.app/Contents/MacOS/Fence"
    for a in "$@"; do case "$a" in -h|--help|-v|--version) exec "$exe" "$@";; esac; done
    nohup "$exe" "$@" >/dev/null 2>&1 &
  SH

  zap trash: [
    "~/Library/Application Support/Fence",
    "~/Library/Preferences/no.helgesverre.fence.plist",
  ]
end
