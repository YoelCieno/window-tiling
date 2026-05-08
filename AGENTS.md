# AGENTS.md — window tiling & startup scripts

Shell scripts for X11 window tiling (`wmctrl` + `xdotool`) and desktop startup profiles. Lives in `~/.local/bin` (on `PATH`).

## Repo layout

- `tiling-common.sh` — sourced by every tiling script; computes screen dims (`xdotool getdisplaygeometry`), exports `SW`, `SH`, and fraction vars (`W_1_2`, `W_1_3`, …, `W_4_5`, `H_1_2`, `H_1_4`). No shebang.
- `quarter/`, `one/`, `three/`, `four/` — executable scripts that `source ../tiling-common.sh`, then call `wmctrl -r :ACTIVE: -e` to resize **active window**.
- `startup-profile-switcher.sh` — `zenity` list dialog → launches `startup/startup-{dev,personal,minimal}.sh`.
- `startup/startup-helpers.sh` — sourced-only `place()` fn: polls `wmctrl -l -x` (15s timeout, 0.5s intervals) for window by class name, removes maximized state, moves/resizes, sends to workspace.
- `startup/startup-{dev,personal,minimal}.sh` — profile scripts sourcing both `tiling-common.sh` and `startup-helpers.sh`.

## Key details for agents

- **Dependencies**: `wmctrl`, `xdotool`, `zenity`.
- **All tiling scripts** follow same 5-line pattern: shebang → `BIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"` → `source "$BIN_ROOT/tiling-common.sh"` → one `wmctrl -r :ACTIVE: -e` call.
- **Startup scripts** use `$(dirname "$0")/` instead of `BIN_ROOT` to source helpers.
- **Signed integer bug**: `wmctrl -e` takes *signed* 16‑bit `x` (max 32767). When `SW > 1366`, right-aligned scripts (e.g. `quarter-top-right`) use x-offsets like `$W_1_2` which stays safe, but scripts combining large offsets may exceed limit → window jumps to x=0. Watch for this when adding new positions on wide/4K monitors.
- **No tests, no CI, no build system**. Add new scripts by copying an existing one and changing the `wmctrl` args.
- **Shebang difference**: `tiling-common.sh` and `startup-helpers.sh` omit shebang (sourced only). Most exec scripts use `#!/bin/bash`; two use `#!/usr/bin/env bash`.
- **Git branches**: `main` and `dev`.
- **Working directory is `~/.local/bin`** — scripts reference each other by relative path from `dirname $0`.
