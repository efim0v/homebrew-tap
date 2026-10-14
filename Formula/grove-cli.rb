class GroveCli < Formula
  desc "Command-line tool for Grove's git-worktree workspaces"
  homepage "https://efimov.page/grove/"
  url "https://github.com/efim0v/grove/releases/download/0.2.2/grove-cli.zip"
  sha256 "b971b7bff1a18a50ba36c9e4d5fa0e70d6fed74459f01c9a2ad80a0f0f104ab6"
  license "GPL-3.0-only"

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
    assert_match version.to_s, shell_output("#{bin}/grove --version")
    assert_match "grove scan <path> [--json]", shell_output("#{bin}/grove help")

    system "git", "init", "--quiet", "--initial-branch=main", testpath/"project/app"
    scan = JSON.parse(shell_output("#{bin}/grove scan #{testpath}/project --json"))
    assert_equal ["app"], scan["repos"].map { |repo| repo["repo"]["dirName"] }
    assert_equal "main", scan["repos"].first["worktrees"].first["branch"]
  end
end
