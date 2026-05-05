# tiling-common.sh – shared tiling variables and helpers
# (Shebang intentionally omitted – this file is never executed directly)

# GAP solved through gtk.css styling
# ASIDE_GAP=60   # compositor shadow on the left/right edges
read -r SW SH < <(xdotool getdisplaygeometry)
