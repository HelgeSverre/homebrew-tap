cask "sourcefour" do
  version "0.1.4"
  sha256 "8a74af92667d3d1783457b0ba8b7b40553a0bf0f8b85985ad4f9abeeaed5475d"

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
