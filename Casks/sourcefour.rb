cask "sourcefour" do
  version "0.1.8"
  sha256 "952b52aa30453a823939d5fdb0d25d6552bf85a7554080c8e84f359d761635a3"

  url "https://github.com/HelgeSverre/sourcefour/releases/download/v#{version}/sourcefour-universal-apple-darwin.zip"
  name "Sourcefour"
  desc "Fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Sourcefour.app"
  binary "#{appdir}/Sourcefour.app/Contents/MacOS/sourcefour"

  uninstall quit: "no.lisethsolutions.sourcefour"
end
