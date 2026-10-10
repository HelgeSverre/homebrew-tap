# frozen_string_literal: true

cask "clickmore" do
  version "0.1.1"
  sha256 "4ac3e9d25fc972679c82aaada859467b37a716f502272e5899fd974c03fb1268"

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
