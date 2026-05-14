#!/usr/bin/env bash
# Personal profile: Firefox, Files

source "$(dirname "$0")/../tiling-common.sh"
source "$(dirname "$0")/startup-helpers.sh"

# ── Launch apps ─────────────────────────────────────────────
vivaldi &
io.elementary.files &

# ── Place windows (workspace 0 = ws1, workspace 1 = ws2) ────
place "vivaldi" 0 0 $W_4_5 $SH 0
place "io.elementary.files" $W_1_2 0 $W_1_2 $H_1_2
