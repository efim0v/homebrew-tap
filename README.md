# Homebrew tap for Brow and Grove

[![tests](https://github.com/efim0v/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/efim0v/homebrew-tap/actions/workflows/tests.yml)

[Homebrew](https://brew.sh) packages for two macOS apps that work with [Claude Code](https://claude.com/claude-code), published by their author:

| Package | Install | What it is |
|---|---|---|
| [`brow`](Casks/brow.rb) (cask) | `brew install --cask efim0v/tap/brow` | [Brow](https://github.com/efim0v/brow) shows, in the MacBook notch, the usage and rate limits of every Claude Code account you have: the 5-hour limit, the weekly limit and when each resets. |
| [`grove`](Casks/grove.rb) (cask) | `brew install --cask efim0v/tap/grove` | [Grove](https://github.com/efim0v/grove) is a menu-bar app that gives each feature of a multi-repo project its own workspace of git worktrees, so parallel Claude Code sessions don't trip over each other's branches. |
| [`grove-cli`](Formula/grove-cli.rb) (formula) | `brew install efim0v/tap/grove-cli` | `grove`, Grove's command-line tool: `scan`, `workspaces`, `sessions`, `create`, `graph` and `doctor`. |

All three need macOS 26 (Tahoe) or later on Apple silicon. Each installs the prebuilt build attached to the app's GitHub release, checked against the SHA-256 from that release's `SHA256SUMS.txt`.

## Install

Use the full name, as in the table. On the first install Homebrew taps `efim0v/tap` by itself and trusts only the package you named ([Tap Trust](https://docs.brew.sh/Tap-Trust)), so there is no separate `brew tap` step.

## First launch

Brow and Grove are signed ad hoc and not notarized by Apple yet. Homebrew quarantines cask downloads so that macOS runs its Gatekeeper check on them ([why](https://docs.brew.sh/Homebrew-Security-and-Supply-Chain#casks-have-a-different-trust-model)), and that check blocks the first launch. To allow an app once:

1. Open the app. macOS refuses to open it.
2. Open **System Settings → Privacy & Security** and scroll down to **Security**.
3. Click **Open Anyway** next to the message about the app, then confirm with your login password.

**Open Anyway** is there for about an hour after you try to open the app ([Apple's guide](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac)). The casks leave the quarantine flag in place; Open Anyway is the way through that Apple documents.

`grove-cli` needs none of this: Homebrew quarantines cask downloads only, so the `grove` command runs right away.

## Updates

Neither app updates itself. New versions come through Homebrew:

```sh
brew update
brew upgrade --cask brow grove
brew upgrade grove-cli
```

`brew update` fetches the latest casks and formula from this tap. `brew upgrade` also runs it by itself, by default at most once a day ([`HOMEBREW_AUTO_UPDATE_SECS`](https://docs.brew.sh/Manpage#environment)). A new version lands here after its GitHub release; each cask's and the formula's `livecheck` block follows the latest release.

Each release is signed ad hoc, so its signature differs from the previous one. Homebrew carries an earlier **Open Anyway** over to an upgraded app only when the signature still matches, so expect macOS to block each upgraded app once and allow it again as above. A running app keeps running the old version until you quit it and open it again.

## Uninstall

```sh
brew uninstall --cask brow
brew uninstall --cask grove
brew uninstall grove-cli
```

`brew uninstall --zap --cask brow` (or `grove`) also moves the app's own files in `~/Library` to the Trash: its settings, Brow's cached readings, network caches and per-account browser profiles, Grove's statistics and scripts. Brow keeps one file in Grove's folder, `~/Library/Application Support/Grove/oauth-usage-ledger.json`; zapping either app removes it, and Brow, if still installed, writes a new one on its next request. `--zap` does not touch Claude Code's own folders, `~/.claude` and `~/.claude-accounts`.

Before you remove Grove, press **Stop** next to *monitoring* for each account on Grove's **Accounts** screen. Grove points a monitored account's Claude Code `statusLine` at a script in `~/Library/Application Support/Grove/bin`, which `--zap` deletes; **Stop** restores the command you had before. Before you remove Brow, turn off **Launch at login** in its settings if you turned it on.

Each app's README lists what it changes on your Mac: [Brow](https://github.com/efim0v/brow#what-brow-does-on-your-machine), [Grove](https://github.com/efim0v/grove#what-grove-does-on-your-machine).

## Problems

Problems with an app itself go to its own issue tracker: [Brow](https://github.com/efim0v/brow/issues), [Grove](https://github.com/efim0v/grove/issues). Problems with a cask or the formula go [here](https://github.com/efim0v/homebrew-tap/issues).

## Releasing a new version

1. Publish the release in the app's repository with its zip files and `SHA256SUMS.txt`.
2. Here, update `version` and `sha256` in the cask, or the version in `url` and `sha256` in the formula, from that `SHA256SUMS.txt`. If the release changes the app's license, update `license` in the formula too: the online audit compares it with the license GitHub detects at the release tag.
3. Open a pull request. The [tests workflow](.github/workflows/tests.yml) runs `brew style`, runs `brew audit --strict --online` on every cask and formula, downloads every release asset to check its SHA-256, and installs and tests the formula.

Once a newer Brow or Grove release is out, the online audit of its cask fails until the cask is bumped, because its `livecheck` finds the newer version.

## License

The files in this repository are under the [BSD 2-Clause License](LICENSE). Brow and Grove are licensed separately; see their repositories.
