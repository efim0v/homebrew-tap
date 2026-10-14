cask "brow" do
  version "0.2.3"
  sha256 "92ff3b3a0d1ae58a6d30dfc7f327e767ec461d8e71ebc15d579df3fb93adfe5f"

  url "https://github.com/efim0v/brow/releases/download/#{version}/Brow.zip"
  name "Brow"
  desc "Notch display of Claude Code usage and rate limits for every account"
  homepage "https://efimov.page/brow/"

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
