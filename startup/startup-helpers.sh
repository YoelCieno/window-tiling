# startup-helpers.sh – shared helpers for startup profile scripts
# (Shebang omitted – this file is sourced, not executed)

# ── Helper: wait until a window's geometry stays unchanged for $stable seconds
wait_until_settled() {
    local wid="$1"
    local stable_time=1
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
        wait_until_settled "$wid"
        wmctrl -i -r "$wid" -e "0,$x,$y,$w,$h"
        wmctrl -i -r "$wid" -t "$ws"
    else
        echo "Window with class '$class' not found." >&2
    fi
}
