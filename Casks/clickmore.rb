# frozen_string_literal: true

cask "clickmore" do
  version "0.1.2"
  sha256 "2b11bcaac248d40a936ba9801a354accbffcf8242447a464b73c7ec1f6af770d"

  url "https://github.com/HelgeSverre/clickmore/releases/download/v#{version}/ClickMore-#{version}-universal.zip"
  name "ClickMore"
  desc "Floating trigger that clicks multiple screen positions in sequence"
  homepage "https://github.com/HelgeSverre/clickmore"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "ClickMore.app"

  uninstall quit: "no.liseth.clickmore"

  caveats <<~EOS
    Enable ClickMore in System Settings → Privacy & Security → Accessibility.
    Launch it from Applications; its controls live in the menu bar and floating overlay.
  EOS
end
