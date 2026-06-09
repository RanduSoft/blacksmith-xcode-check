# blacksmith-xcode-check

Tracks which **Xcode versions are actually installed on [Blacksmith](https://blacksmith.sh) macOS runners**.

## Installed Xcode versions

<!-- XCODE-LIST:START -->
_Last checked: **2026-06-09 09:27 UTC** — runner macOS 26.3 (25D125)_

| Xcode | Build | Path | Default |
| --- | --- | --- | :---: |
| 26.4 | `17E192` | `/Applications/Xcode_26.4.app` |  |
| 26.3 | `17C529` | `/Applications/Xcode_26.3.app` |  |
| 26.2 | `17C52` | `/Applications/Xcode_26.2.app` | ✅ |
| 26.1.1 | `17B100` | `/Applications/Xcode_26.1.1.app` |  |
| 26.0.1 | `17A400` | `/Applications/Xcode_26.0.1.app` |  |

> ✅ marks the default toolchain selected by `xcode-select` (what a plain `xcodebuild` uses).
<!-- XCODE-LIST:END -->

## Why this exists

Blacksmith [documents](https://docs.blacksmith.sh/blacksmith-runners/overview#macos) that its macOS runners "follow the corresponding GitHub-hosted macOS runner images" but in practice they lag behind. As of writing, Xcode 26.5 ships on the GitHub-hosted `macos-latest` image but is **not** present on Blacksmith yet, and Blacksmith does not publish the exact contents anywhere.

This repo runs a tiny GitHub Action **once a day** on a `blacksmith-6vcpu-macos-latest` runner, lists every Xcode install it finds, and commits the result back to this README. So the table above is always the real, current state of the runner image.

> 💡 **Want to be notified when a new Xcode lands on Blacksmith?** Watch this repo's **Releases** (Watch → Custom → Releases). A release titled with the date is published automatically whenever a new Xcode version shows up.
