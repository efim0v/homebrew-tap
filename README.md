# Homebrew tap for Brow

[![tests](https://github.com/efim0v/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/efim0v/homebrew-tap/actions/workflows/tests.yml)

[Homebrew](https://brew.sh) packages for [Brow](https://github.com/efim0v/brow), a macOS app that works with [Claude Code](https://claude.com/claude-code), published by its author:

| Package | Install | What it is |
|---|---|---|
| [`brow`](Casks/brow.rb) (cask) | `brew install --cask efim0v/tap/brow` | [Brow](https://github.com/efim0v/brow) shows, in the MacBook notch, the usage and rate limits of every Claude Code account you have: the 5-hour limit, the weekly limit and when each resets. Its Workspaces, in the same panel, gives each feature of a multi-repo project its own folder of git worktrees, so parallel Claude Code sessions don't trip over each other's branches. |
| [`brow-cli`](Formula/brow-cli.rb) (formula) | `brew install efim0v/tap/brow-cli` | `brow`, the command-line tool for Workspaces: `scan`, `workspaces`, `sessions`, `create`, `graph` and `doctor`. It also answers to `grove`, its name in Grove. |
| [`grove`](Casks/grove.rb) (cask, deprecated) | | Grove has moved into Brow, as Workspaces: see [Coming from Grove](#coming-from-grove). The cask stays for Grove 0.2.2 and points to Brow. |

Both need macOS 26 (Tahoe) or later on Apple silicon. Each installs the prebuilt build attached to Brow's GitHub release, checked against the SHA-256 from that release's `SHA256SUMS.txt`.

## Install

Use the full name, as in the table. On the first install Homebrew taps `efim0v/tap` by itself and trusts only the package you named ([Tap Trust](https://docs.brew.sh/Tap-Trust)), so there is no separate `brew tap` step.

## Coming from Grove

Grove is now part of Brow, and Brow picks up Grove's projects, accounts and settings by itself ([what changes](https://github.com/efim0v/brow#coming-from-grove)). Install Brow, quit Grove, then remove Grove and its command-line tool:

```sh
brew install --cask efim0v/tap/brow
brew uninstall --cask grove
brew uninstall grove-cli               # if you have it
brew install efim0v/tap/brow-cli       # brow, with grove as a second name
```

Leave out `--zap` when you remove Grove. A Grove cask installed before the move zaps with the list it was installed with, which moves `~/Library/Application Support/Grove` to the Trash, and Brow's Workspaces keeps its config there, along with the status-line wrappers that captured accounts' `settings.json` run.

`grove-cli` is `brow-cli` now, a rename recorded in [`formula_renames.json`](formula_renames.json). Remove `grove-cli` before you install `brow-cli`: Homebrew takes `brow-cli` for the renamed `grove-cli` and won't install it next to the old one.

## First launch

Brow is signed ad hoc and not notarized by Apple yet, and so is Grove. Homebrew quarantines cask downloads so that macOS runs its Gatekeeper check on them ([why](https://docs.brew.sh/Homebrew-Security-and-Supply-Chain#casks-have-a-different-trust-model)), and that check blocks the first launch. To allow the app once:

1. Open the app. macOS refuses to open it.
2. Open **System Settings → Privacy & Security** and scroll down to **Security**.
3. Click **Open Anyway** next to the message about the app, then confirm with your login password.

**Open Anyway** is there for about an hour after you try to open the app ([Apple's guide](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac)). The casks leave the quarantine flag in place; Open Anyway is the way through that Apple documents.

`brow-cli` needs none of this: Homebrew quarantines cask downloads only, so the `brow` command runs right away.

## Updates

Brow doesn't update itself. New versions come through Homebrew. Upgrade each package you installed:

```sh
brew update
brew upgrade --cask brow
brew upgrade brow-cli
```

`brew update` fetches the latest casks and formula from this tap. `brew upgrade` also runs it by itself, by default at most once a day ([`HOMEBREW_AUTO_UPDATE_SECS`](https://docs.brew.sh/Manpage#environment)). A new version lands here after its GitHub release; each cask's and the formula's `livecheck` block follows the latest release.

Each release is signed ad hoc, so its signature differs from the previous one. Homebrew carries an earlier **Open Anyway** over to an upgraded app only when the signature still matches, so expect macOS to block each upgraded app once and allow it again as above. A running app keeps running the old version until you quit it and open it again.

## Uninstall

```sh
brew uninstall --cask brow
brew uninstall brow-cli
```

`brew uninstall --zap --cask brow` also moves Brow's own files in `~/Library` to the Trash: its settings, cached readings, network caches, the pet's state and per-account browser profiles, and Workspaces' config, code statistics and request-pacing file in `~/Library/Application Support/Grove`. It leaves that folder's `bin/`, the status-line wrappers: a captured account's Claude Code `statusLine` runs one of them. Before you remove Brow, turn off **Capture the status line** for every account in its Settings → Accounts, and **Launch at login** in Settings → General if you turned it on. [Brow's README](https://github.com/efim0v/brow#uninstall) has every step, deleting the wrappers included. `--zap` does not touch Claude Code's own folders, `~/.claude` and `~/.claude-accounts`.

[What Brow does on your machine](https://github.com/efim0v/brow#what-brow-does-on-your-machine) lists everything Brow changes.

## Problems

Problems with Brow itself, Workspaces included, go to [its issue tracker](https://github.com/efim0v/brow/issues). Problems with a cask or the formula go [here](https://github.com/efim0v/homebrew-tap/issues).

## Releasing a new version

1. Publish the release in Brow's repository with `Brow.zip`, `brow-cli.zip` and `SHA256SUMS.txt`.
2. Here, update `version` and `sha256` in `Casks/brow.rb`, and the version in `url` and `sha256` in `Formula/brow-cli.rb`, from that `SHA256SUMS.txt`. If the release changes the license, update `license` in the formula too. CI won't catch a stale one: `brew audit` compares a formula's license with GitHub's only in homebrew/core.
3. Open a pull request. The [tests workflow](.github/workflows/tests.yml) runs `brew style`, runs `brew audit --strict --online` on every cask and formula, downloads every release asset to check its SHA-256, and installs and tests the formula.

Once a newer Brow release is out, the online audit of its cask fails until the cask is bumped, because its `livecheck` finds the newer version.

## License

The files in this repository are under the [BSD 2-Clause License](LICENSE). Brow and Grove are licensed separately; see their repositories.
