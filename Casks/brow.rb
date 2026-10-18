cask "brow" do
  version "0.4.0"
  sha256 "6e70faa7400035be9a9ddbc34c4a71bfc7e5da6c46eb141e232444d008f62e8f"

  url "https://github.com/efim0v/brow/releases/download/#{version}/Brow.zip"
  name "Brow"
  desc "Claude Code usage limits in the notch, and workspaces for parallel sessions"
  homepage "https://efimov.page/brow/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Brow.app"

  # Workspaces keeps its files in Grove's folder, where Grove.app kept them, and Brow its
  # request-pacing ledger. Its bin/ holds the status-line wrappers that captured accounts'
  # settings.json run, so zap leaves bin/ alone; rmdir removes it, and the folder, only empty.
  zap trash: [
        "~/Library/Application Support/Brow",
        "~/Library/Application Support/Grove/config.json",
        "~/Library/Application Support/Grove/config.json.bak",
        "~/Library/Application Support/Grove/oauth-usage-ledger.json",
        "~/Library/Application Support/Grove/stats",
        "~/Library/Application Support/Grove/workspaces.lock",
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

    `brew uninstall --zap` leaves Workspaces' status-line wrappers in
    ~/Library/Application Support/Grove/bin, which captured accounts'
    settings.json run. To remove them, first turn off Capture the status
    line for every account in Brow's Settings → Accounts; Brow's README
    has the steps: https://github.com/efim0v/brow#uninstall
  EOS
end
