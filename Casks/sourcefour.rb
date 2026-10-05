cask "sourcefour" do
  version "0.1.7"
  sha256 "b0d5d06b6c6122a519202f849e753724db246a36a5b708d3d6e95dad5ab7c858"

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
