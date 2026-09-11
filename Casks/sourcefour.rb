cask "sourcefour" do
  version "0.1.3"
  sha256 "ec9482e7047db170fedcf919ed6f16826ca62f3e7ee0cce1690cde46673b85af"

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
