#!/bin/bash
# startup-dev.sh – Development profile (KISSME, no workspace pre‑creation)

source "$(dirname "$0")/startup-helpers.sh"

# ── Get screen dimensions ───────────────────────────────────
read SW SH < <(xdotool getdisplaygeometry)

# ── Compute fractions ───────────────────────────────────────
left_4_5=$(( SW * 4 / 5 ))
right_1_5=$(( SW - left_4_5 ))
right_1_3=$(( SW / 3 ))
left_2_3=$(( SW - right_1_3 ))

# ── Launch apps ─────────────────────────────────────────────
firefox &
io.elementary.terminal &
zed &

# ── Place windows (workspace 0 = ws1, workspace 1 = ws2) ────
place "dev.zed.Zed" $right_1_5 0 $left_4_5 $SH 1
