cask "sourcefour" do
  version "0.1.9"
  sha256 "677665f0cbb77517fad5077b64a76c1079e27ae46a0a538061f8a6eafd7a80a7"

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
