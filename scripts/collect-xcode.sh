#!/usr/bin/env bash
# Collects every Xcode install on the runner and renders a Markdown snapshot.
# Output goes to stdout and is injected into README.md between the marker comments.
set -euo pipefail

selected_dir="$(xcode-select -p 2>/dev/null || true)"
# resolve the symlink-y developer dir down to its real .app bundle
selected_app="$(cd "${selected_dir%/Contents/Developer}" 2>/dev/null && pwd -P || true)"

rows=""
seen=""
shopt -s nullglob
# match Xcode.app and Xcode_<version>.app, but not Xcodes.app (the version manager)
for app in /Applications/Xcode.app /Applications/Xcode_*.app; do
  [ -d "$app" ] || continue
  # collapse symlinks (e.g. Xcode.app -> Xcode_26.5.app) so each install is listed once
  real="$(cd "$app" 2>/dev/null && pwd -P || echo "$app")"
  case "$seen" in *"|$real|"*) continue ;; esac
  seen+="|$real|"

  short="$(/usr/bin/defaults read "$real/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "?")"
  build="$(/usr/bin/defaults read "$real/Contents/version" ProductBuildVersion 2>/dev/null || echo "?")"
  app="$real"
  default_mark=""
  [ -n "$selected_app" ] && [ "$selected_app" = "$real" ] && default_mark="✅"
  # sortable key: zero-pad each version component
  key="$(printf '%s' "$short" | awk -F. '{ printf "%03d%03d%03d", $1, $2, $3 }')"
  rows+="$key|$short|$build|$app|$default_mark"$'\n'
done

table="| Xcode | Build | Path | Default |"$'\n'"| --- | --- | --- | :---: |"$'\n'
while IFS='|' read -r key short build path mark; do
  [ -z "${short:-}" ] && continue
  table+="| $short | \`$build\` | \`$path\` | $mark |"$'\n'
done < <(printf '%s' "$rows" | sort -r)

runner_os="$(sw_vers -productVersion 2>/dev/null || echo "?") ($(sw_vers -buildVersion 2>/dev/null || echo "?"))"
stamp="$(date -u '+%Y-%m-%d %H:%M UTC')"

printf '_Last checked: **%s** — runner macOS %s_\n\n' "$stamp" "$runner_os"
printf '%s' "$table"
printf '\n> ✅ marks the default toolchain selected by `xcode-select` (what a plain `xcodebuild` uses).\n'
