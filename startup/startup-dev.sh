#!/bin/bash
# startup-dev.sh – Development profile (KISSME, no workspace pre‑creation)

source "$(dirname "$0")/../tiling-common.sh"
source "$(dirname "$0")/startup-helpers.sh"

# ── Launch apps ─────────────────────────────────────────────
firefox &
io.elementary.terminal &
zed &
obsidian &

# ── Place windows (workspace 0 = ws1, workspace 1 = ws2) ────
place "firefox" 0 0 $W_4_5 $SH 0
place "obsidian" $W_2_3 0 $W_1_3 $SH 0
place "dev.zed.Zed" 0 0 $W_4_5 $SH 1
place "io.elementary.terminal" $W_2_3 0 $W_1_3 $SH 1
