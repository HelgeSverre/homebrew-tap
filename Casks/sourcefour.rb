cask "sourcefour" do
  version "0.1.5"
  sha256 "95fe9d2a0bcdfdf92f928b94db90b77bb73343221e0f328b0cd6262ed008964e"

  url "https://github.com/HelgeSverre/sourcefour/releases/download/v#{version}/sourcefour-universal-apple-darwin.pkg"
  name "Sourcefour"
  desc "Fast, native Git history browser you launch from your terminal"
  homepage "https://github.com/HelgeSverre/sourcefour"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  pkg "sourcefour-universal-apple-darwin.pkg"
  binary "/Applications/Sourcefour.app/Contents/MacOS/sourcefour"

  uninstall quit:    "no.lisethsolutions.sourcefour",
            pkgutil: "no.lisethsolutions.sourcefour"
end
