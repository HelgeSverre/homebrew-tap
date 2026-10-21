cask "fence" do
  version "0.8.0"
  sha256 arm:   "eab31cd6067c12d9634a9882ffad330397012ce70b8024b3c14c83c41d67334f",
         intel: "67f532d7013702080b5b8aea4904fa716bb03756ddbefd7a8cd0ec8f70d591c9"

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
