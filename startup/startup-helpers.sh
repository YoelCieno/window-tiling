# startup-helpers.sh – shared helpers for startup profile scripts
# (Shebang omitted – this file is sourced, not executed)

# ── Helper: wait for window and return its ID ───────────────
get_wid() {
    local class="$1"
    local wid
    # Wait up to 15 seconds for the main window to appear
    for i in {1..15}; do
        # Get the first window ID from wmctrl that matches the class (case‑insensitive)
        wid=$(wmctrl -l -x | grep -i "$class" | awk '{print $1}' | head -1)
        [ -n "$wid" ] && break
        sleep 1
    done
    echo "$wid"
}

# ── Helper: place window by ID ──────────────────────────────
place_window() {
    local wid="$1" class="$2" x="$3" y="$4" w="$5" h="$6" ws="$7"
    if [ -n "$wid" ]; then
        # Remove any maximised state (sometimes prevents moving)
        wmctrl -i -r "$wid" -b remove,maximized_vert,maximized_horiz 2>/dev/null
        # Move and resize using wmctrl (proven to work)
        wmctrl -i -r "$wid" -e "0,$x,$y,$w,$h"
        # Move to the desired workspace
        wmctrl -i -r "$wid" -t "$ws"
        echo "Window class '$class' moved to $x,$y $w,$h on workspace $ws (ID=$wid)" >&2
    else
        echo "Window with class '$class' not found." >&2
    fi
}

# ── Helper: place a window by class name ────────────────────
place() {
    local class="$1" x="$2" y="$3" w="$4" h="$5" ws="$6"
    local wid=$(get_wid "$class")
    place_window "$wid" "$class" "$x" "$y" "$w" "$h" "$ws"
}
