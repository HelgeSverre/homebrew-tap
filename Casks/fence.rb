cask "fence" do
  version "0.6.0"
  sha256 arm:   "e00b8c35461fd00c0846bd6d695ff61ff27519a42be5069498abae9641c0c130",
         intel: "34d692843a372b26f5c630496ade9c9cdf00730f41ee0b59cfe7788472698b28"

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
