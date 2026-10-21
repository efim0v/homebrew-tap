class BrowCli < Formula
  desc "Command-line tool for Brow's git-worktree workspaces across repositories"
  homepage "https://efimov.page/brow/"
  url "https://github.com/efim0v/brow/releases/download/0.5.0/brow-cli.zip"
  sha256 "0165abb5acb157c47b28c49c5a67086a2c6f4d76e001a0b34c4cb36bb7193ee0"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "brow"
    # Grove's name for the same tool, so scripts written for grove-cli keep working.
    bin.install_symlink "brow" => "grove"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brow --version")
    assert_match "brow scan <path> [--json]", shell_output("#{bin}/brow help")
    assert_match "grove scan <path> [--json]", shell_output("#{bin}/grove help")

    system "git", "init", "--quiet", "--initial-branch=main", testpath/"project/app"
    scan = JSON.parse(shell_output("#{bin}/brow scan #{testpath}/project --json"))
    assert_equal ["app"], scan["repos"].map { |repo| repo["repo"]["dirName"] }
    assert_equal "main", scan["repos"].first["worktrees"].first["branch"]
  end
end
