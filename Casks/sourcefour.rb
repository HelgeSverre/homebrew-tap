cask "sourcefour" do
  version "0.1.1"
  sha256 "fb24c9a563e127a459b136ee11ed49b9fa14611f3099f18e126b8f6d37bf3d61"

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
