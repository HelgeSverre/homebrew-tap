# frozen_string_literal: true

cask "clickmore" do
  version "0.1.3"
  sha256 "029b33a531a88c48b50303571b7b3bb097a48c4c493cbf8fc9dca5f01ecfde4f"

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
