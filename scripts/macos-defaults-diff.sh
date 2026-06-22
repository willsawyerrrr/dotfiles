#!/usr/bin/env zsh
#
# Capture which `defaults` key a System Settings change touched.
#
#   1. Run this script — it snapshots all domains to a "before" file.
#   2. Make the change in System Settings (toggle the thing you care about).
#   3. Press Enter — it snapshots an "after" file and diffs the two.
#
# The diff shows the domain/key/value that changed, ready to paste into
# scripts/macos-defaults.sh as a `defaults write` line.

set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

# Drop timestamp churn so it doesn't swamp the diff:
#   - values formatted "YYYY-MM-DD HH:MM:SS +ZZZZ"
#   - keys named *timestamp* (e.g. timestamp, timestampLastReplenished)
# Many domains rewrite these on every read.
snapshot() {
    defaults read 2>/dev/null \
        | grep -Eiv '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}|[a-z]*timestamp[a-z]* = ' >"$1"
}

echo "Snapshotting current defaults..."
snapshot "${tmp}/before.plist"

echo
echo "Now make your change in System Settings, then press Enter to capture the diff."
read -r

snapshot "${tmp}/after.plist"

echo
echo "=== Changed defaults (- before / + after) ==="
delta "${tmp}/before.plist" "${tmp}/after.plist" || true
