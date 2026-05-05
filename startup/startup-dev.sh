#!/bin/bash
# startup-dev.sh – Development profile (KISSME, no workspace pre‑creation)

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

# ── Helper: wait until a window’s geometry stays unchanged for $stable seconds
wait_until_settled() {
    local wid="$1"
    local stable_time=1   # seconds of no change
    local prev_geom=""
    local count=0
    while [ $count -lt $stable_time ]; do
        local curr_geom=$(xdotool getwindowgeometry "$wid" 2>/dev/null | grep -E "Position|Geometry" | tr '\n' ' ')
        if [ "$curr_geom" = "$prev_geom" ]; then
            count=$((count+1))
        else
            count=0
            prev_geom="$curr_geom"
        fi
        sleep 1
    done
}

# ── Helper: place a window by class name ────────────────────
place() {
    local class="$1" x="$2" y="$3" w="$4" h="$5" ws="$6"
    local wid
    for i in {1..15}; do
        wid=$(xdotool search --class "$class" | head -1)
        [ -n "$wid" ] && break
        sleep 1
    done
    if [ -n "$wid" ]; then
        # Wait until the window geometry stops changing
        wait_until_settled "$wid"
        wmctrl -i -r "$wid" -e "0,$x,$y,$w,$h"
        wmctrl -i -r "$wid" -t "$ws"   # ← creates workspace if not exists
    else
        echo "Window with class '$class' not found." >&2
    fi
}

# ── Place windows (workspace 0 = ws1, workspace 1 = ws2) ────
place "dev.zed.Zed" $right_1_5 0 $left_4_5 $SH 1
