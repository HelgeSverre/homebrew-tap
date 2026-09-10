cask "zest" do
  version "0.1.1"
  sha256 "ac486ce8e98fa4bd70ebcc60042062fbed54c0c5d50f0485cfa4f1f1fd52c192"

  url "https://github.com/HelgeSverre/zest/releases/download/v#{version}/zest-universal-apple-darwin.pkg"
  name "Zest"
  desc "Fast native file browser with background indexing"
  homepage "https://github.com/HelgeSverre/zest"

  depends_on macos: :sonoma

  pkg "zest-universal-apple-darwin.pkg"
  binary "/Applications/Zest.app/Contents/MacOS/Zest", target: "zest"
  binary "/Applications/Zest.app/Contents/Helpers/zest-query"
  binary "/Applications/Zest.app/Contents/Helpers/zest-indexer"

  uninstall launchctl: "dev.zest.app.indexer",
            quit:      "dev.zest.app",
            pkgutil:   "^dev[.]zest[.]app$"

  caveats <<~EOS
    Open Zest and choose Index > Set Up Indexer to enable background indexing.
    Terminal commands: zest, zest-query, zest-indexer.
    Manage the app's background service from the Index menu, not indexer CLI install/start commands.
    Full Disk Access is optional; without it, some locations cannot be indexed.
    Before upgrading or uninstalling, choose Index > Disable Background Indexing.
    Your index and preferences are retained on uninstall.
    This is an initial beta; see the release notes for known limitations.
  EOS
end
