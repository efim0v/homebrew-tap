cask "brow" do
  version "0.2.0"
  sha256 "f1eeba165ea66d31113c88430f92a6e4afb93db4629ead7b451e457f7bda87f8"

  url "https://github.com/efim0v/brow/releases/download/#{version}/Brow.zip"
  name "Brow"
  desc "Notch display of Claude Code usage and rate limits for every account"
  homepage "https://efim0v.github.io/brow/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Brow.app"

  # Brow keeps its request-pacing ledger in Grove's folder (GroveCore's default).
  zap trash: [
        "~/Library/Application Support/Brow",
        "~/Library/Application Support/Grove/oauth-usage-ledger.json",
        "~/Library/Caches/dev.artemefimov.brow",
        "~/Library/HTTPStorages/dev.artemefimov.brow",
        "~/Library/Preferences/dev.artemefimov.brow.plist",
      ],
      rmdir: "~/Library/Application Support/Grove"

  caveats <<~EOS
    Brow is signed ad hoc and not notarized by Apple yet, so macOS blocks
    the first launch. To allow it once, open Brow, then in
    System Settings → Privacy & Security scroll down to Security,
    click Open Anyway and confirm with your login password.
  EOS
end
