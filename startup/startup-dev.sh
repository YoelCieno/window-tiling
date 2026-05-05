#!/bin/bash
# startup-dev.sh – Development profile (KISSME, no workspace pre‑creation)

source "$(dirname "$0")/../tiling-common.sh"
source "$(dirname "$0")/startup-helpers.sh"

# ── Launch apps ─────────────────────────────────────────────
firefox &
io.elementary.terminal &
zed &

# ── Place windows (workspace 0 = ws1, workspace 1 = ws2) ────
place "dev.zed.Zed" $((SW - W_4_5)) 0 $W_4_5 $SH 1
