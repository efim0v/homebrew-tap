class GroveCli < Formula
  desc "Command-line tool for Grove's git-worktree workspaces"
  homepage "https://github.com/efim0v/grove"
  url "https://github.com/efim0v/grove/releases/download/0.2.0/grove-cli.zip"
  sha256 "7e84db562657088e7759ecd868144bd04a26b6f381d7679a4744287938c60270"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove scan <path> [--json]", shell_output("#{bin}/grove help")

    system "git", "init", "--quiet", "--initial-branch=main", testpath/"project/app"
    scan = JSON.parse(shell_output("#{bin}/grove scan #{testpath}/project --json"))
    assert_equal ["app"], scan["repos"].map { |repo| repo["repo"]["dirName"] }
    assert_equal "main", scan["repos"].first["worktrees"].first["branch"]
  end
end
