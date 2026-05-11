# tiling-common.sh – shared tiling variables and helpers
# (Shebang intentionally omitted – this file is never executed directly)

# GAP solved through gtk.css styling
# ASIDE_GAP=60   # compositor shadow on the left/right edges

# ── Screen dimensions ───────────────────────────────────────
read -r SW SH < <(xdotool getdisplaygeometry)

# ── Common fractions ────────────────────────────────────────
W_1_2=$(( SW / 2 ))
W_1_3=$(( SW / 3 ))
W_1_4=$(( SW / 4 ))
W_1_5=$(( SW / 5 ))
W_2_3=$(( SW * 2 / 3 ))
W_3_4=$(( SW * 3 / 4 ))
W_4_5=$(( SW * 4 / 5 ))

H_1_2=$(( SH / 2 ))
H_1_4=$(( SH / 4 ))

# ── Fixed adjustment deltas (pixels) ────────────────────────
W_STEP=200   # Width step (+ to widen, - to narrow)
H_STEP=100    # Height step (+ to tall, - to shorten)

# ── Helper: get active window geometry ────────────────────────
get_active_geometry() {
    local wid
    wid=$(xdotool getactivewindow 2>/dev/null) || {
        echo "Error: No active window or xdotool not available" >&2
        return 1
    }
    eval $(xdotool getwindowgeometry --shell "$wid") || {
        echo "Error: Failed to get window geometry" >&2
        return 1
    }
    # Return window ID for wmctrl usage
    echo "$wid"
}

# ── Helper: apply window geometry ────────────────────────────────
apply_window_geometry() {
    local wid="$1"
    local new_w="$2"
    local new_h="$3"
    local x="${4:-$X}"
    local y="${5:-$Y}"

    wmctrl -i -r "$wid" -e 0,"$x","$y",$new_w,$new_h 2>/dev/null || {
        echo "Error: wmctrl failed" >&2
        return 1
    }
}

# ── Helper: clamp value within bounds ────────────────────────────
clamp() {
    local val="$1"
    local min="$2"
    local max="$3"
    [ "$val" -lt "$min" ] && val=$min
    [ "$val" -gt "$max" ] && val=$max
    echo "$val"
}
