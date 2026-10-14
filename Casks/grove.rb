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

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Grove.app"

  zap trash: [
    "~/Library/Application Support/Grove",
    "~/Library/Preferences/dev.artemefimov.grove3.plist",
  ]

  caveats <<~EOS
    Grove is signed ad hoc and not notarized by Apple yet, so macOS blocks
    the first launch. To allow it once, open Grove, then in
    System Settings → Privacy & Security scroll down to Security,
    click Open Anyway and confirm with your login password.

    Grove opens Claude Code sessions in cmux; its launch sheet can open
    them in Terminal instead. To install cmux:
      brew install --cask cmux
  EOS
end
