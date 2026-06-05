# blacksmith-xcode-check

Tracks which **Xcode versions are actually installed on [Blacksmith](https://blacksmith.sh) macOS runners**.

## Why this exists

Blacksmith [documents](https://docs.blacksmith.sh/blacksmith-runners/overview#macos) that its macOS runners "follow the corresponding GitHub-hosted macOS runner images" but in practice they lag behind. As of writing, Xcode 26.5 ships on the GitHub-hosted `macos-latest` image but is **not** present on Blacksmith yet, and Blacksmith does not publish the exact contents anywhere.

This repo runs a tiny GitHub Action **once a day** on a `blacksmith-6vcpu-macos-latest` runner, lists every Xcode install it finds, and commits the result back to this README. So the table below is always the real, current state of the runner image.

> 💡 **Want to be notified when a new Xcode lands on Blacksmith?** Watch this repo's **Releases** (Watch → Custom → Releases). A release titled with the date is published automatically whenever a new Xcode version shows up.

## Installed Xcode versions

<!-- XCODE-LIST:START -->
_Not yet populated — the daily workflow will fill this in on its first run._
<!-- XCODE-LIST:END -->

## How it works

- [`.github/workflows/check-xcode.yml`](.github/workflows/check-xcode.yml) runs daily (and on demand via `workflow_dispatch`)
- [`scripts/collect-xcode.sh`](scripts/collect-xcode.sh) reads each `/Applications/Xcode*.app` version + build number straight from its `Info.plist`
- the script output replaces everything between the `XCODE-LIST` markers above, and the workflow commits the change only when something actually changed
- when a brand-new version number appears, the workflow also cuts a GitHub **release** (titled with the date) so watchers get notified

Run it yourself: **Actions → Check Blacksmith Xcode versions → Run workflow**.
