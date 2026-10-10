# frozen_string_literal: true

cask "clickmore" do
  version "0.1.0"
  sha256 "0c3cab3e5ae820fb6f4b8a05757c98fcf04aba5ebae5c890d96d117b205a3cf6"

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
