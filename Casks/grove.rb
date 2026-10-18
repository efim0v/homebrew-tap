cask "grove" do
  version "0.2.2"
  sha256 "6f13f37ac90883169811fc281b181641998fbefd21ed1bd34cfaa73f314f9512"

  url "https://github.com/efim0v/grove/releases/download/#{version}/Grove.zip"
  name "Grove"
  desc "Git-worktree workspaces for parallel Claude Code sessions"
  homepage "https://efimov.page/grove/"

  livecheck do
    url :url
    strategy :github_latest
  end

  deprecate! date: "2026-10-18", because: "is now part of Brow", replacement_cask: "efim0v/tap/brow"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Grove.app"

  # Brow's Workspaces now uses ~/Library/Application Support/Grove: its config, and the
  # status-line wrappers in bin/ that captured accounts' settings.json run. Zapping Grove
  # leaves the folder to Brow's cask.
  zap trash: "~/Library/Preferences/dev.artemefimov.grove3.plist"

  caveats <<~EOS
    Grove is now part of Brow, as Workspaces. Brow picks up Grove's
    projects, accounts and settings by itself:
      brew install --cask efim0v/tap/brow

    Quit Grove before you open Brow. Then remove it without --zap, since
    Brow keeps using ~/Library/Application Support/Grove:
      brew uninstall --cask grove

    Grove is signed ad hoc and not notarized by Apple yet, so macOS blocks
    the first launch. To allow it once, open Grove, then in
    System Settings → Privacy & Security scroll down to Security,
    click Open Anyway and confirm with your login password.
  EOS
end
