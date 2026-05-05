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
