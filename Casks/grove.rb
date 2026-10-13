cask "grove" do
  version "0.2.0"
  sha256 "5ae89683ef13e405a150f953341f5136621de7ecde3e6035a4d8c049b29ade89"

  url "https://github.com/efim0v/grove/releases/download/#{version}/Grove.zip"
  name "Grove"
  desc "Git-worktree workspaces for parallel Claude Code sessions"
  homepage "https://efim0v.github.io/grove/"

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
