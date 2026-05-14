# X11 Window Tiling & Startup Scripts

Lightweight window tiling and desktop startup profile management for X11 using `wmctrl`, `xdotool`, and `zenity`.

## Dependencies

- `wmctrl` — window manipulation (move, resize, workspace)
- `xdotool` — display geometry, active window ID, window info
- `zenity` — profile selection dialog (startup only)

## Installation

```bash
git clone <repo> ~/.local/bin
```

Ensure `~/.local/bin` is on `PATH`. Scripts reference each other via relative paths from `dirname $0`.

## Usage

### Window Tiling

Run any script to position the **active window**:

| Command | Effect |
|---|---|
| `quarter/quarter-top-left` | Top-left quadrant |
| `quarter/quarter-top-right` | Top-right quadrant |
| `quarter/quarter-bottom-left` | Bottom-left quadrant |
| `quarter/quarter-bottom-right` | Bottom-right quadrant |
| `quarter/quarter-center` | Centered quarter |
| `one/one-half-left` | Left half |
| `one/one-half-right` | Right half |
| `one/one-third-left` | Left third |
| `one/one-third-right` | Right third |
| `one/one-fifth-left` | Left fifth |
| `one/one-fifth-right` | Right fifth |
| `three/three-quarters-left` | Left three-quarters |
| `three/three-quarters-right` | Right three-quarters |
| `four/four-fifths-left` | Left four-fifths |
| `four/four-fifths-right` | Right four-fifths |

### Incremental Resize

Nudge active window dimensions:

| Command | Effect |
|---|---|
| `increase/increase-width` | Widen by `W_STEP` (100px) |
| `increase/increase-height` | Heighten by `H_STEP` (50px) |
| `decrease/decrease-width` | Narrow by `W_STEP` |
| `decrease/decrease-height` | Shorten by `H_STEP` |

### Startup Profiles

```bash
./startup-profile-switcher.sh
```

Presents a `zenity` list dialog with three profiles:
- **Development** — launches Firefox, terminal, Zed, Obsidian; arranges across workspaces
- **Personal** — personal workspace apps
- **Minimal** — minimal session

Default fallback is Development.

## Directory Structure

```
~/.local/bin/
├── tiling-common.sh              # Shared screen dims, fractions, helpers
├── startup-profile-switcher.sh   # Zenity profile picker
├── quarter/                      # 5 scripts: 4 quadrants + center
├── one/                          # 6 scripts: 1/2, 1/3, 1/5 left/right
├── three/                        # 2 scripts: 3/4 left/right
├── four/                         # 2 scripts: 4/5 left/right
├── increase/                     # 2 scripts: increase width/height
├── decrease/                     # 2 scripts: decrease width/height
└── startup/
    ├── startup-helpers.sh        # Sourced helpers: get_wid, place_window, place
    ├── startup-dev.sh            # Development profile
    ├── startup-personal.sh       # Personal profile
    └── startup-minimal.sh        # Minimal profile
```

## Script Architecture

### tiling-common.sh

Shared variables and helper functions. Sourced by all tiling scripts.

**Geometry fractions** (derived from `xdotool getdisplaygeometry`):

| Variable | Value |
|---|---|
| `SW`, `SH` | Screen width, height |
| `W_1_2` | `SW / 2` |
| `W_1_3` | `SW / 3` |
| `W_1_4` | `SW / 4` |
| `W_1_5` | `SW / 5` |
| `W_2_3` | `SW * 2 / 3` |
| `W_3_4` | `SW * 3 / 4` |
| `W_4_5` | `SW * 4 / 5` |
| `H_1_2` | `SH / 2` |
| `H_1_4` | `SH / 4` |
| `W_STEP` | Width increment (100px) |
| `H_STEP` | Height increment (50px) |

**Helper functions**:

- `get_active_geometry` — resolves active window decimal ID via `xdotool getactivewindow`, converts to hex for `wmctrl`, outputs `hex_wid X Y WIDTH HEIGHT`
- `load_active_geometry` — parses `get_active_geometry` output into `$WID $X $Y $WIDTH $HEIGHT`
- `clamp VALUE MIN MAX` — constrains value within range
- `apply_window_geometry WID W H [X] [Y]` — calls `wmctrl -i -r` with bounds

### Tiling Script Pattern

All static tiling scripts follow this pattern:

```bash
#!/bin/bash
BIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$BIN_ROOT/tiling-common.sh"

wmctrl -r :ACTIVE: -e 0,X,Y,WIDTH,HEIGHT
```

### Incremental Resize Script Pattern

```bash
#!/bin/bash
BIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$BIN_ROOT/tiling-common.sh"

load_active_geometry
UPDATED_WIDTH=$(clamp $((WIDTH + W_STEP)) 1 $SW)
apply_window_geometry "$WID" "$UPDATED_WIDTH" "$HEIGHT"
```

### Startup Script Pattern

```bash
#!/bin/bash
source "$(dirname "$0")/../tiling-common.sh"
source "$(dirname "$0")/startup-helpers.sh"

app1 &
app2 &

place "app.class" X Y WIDTH HEIGHT WORKSPACE
```

**startup-helpers.sh functions**:

- `get_wid CLASS` — polls `wmctrl -l -x` for window by class (15s timeout, 1s intervals), returns hex window ID
- `place_window WID CLASS X Y W H WS` — removes maximized state, moves/resizes, sends to workspace
- `place CLASS X Y W H WS` — convenience wrapper: calls `get_wid` then `place_window`

## Configuration

### Adjust Steps

Edit in `tiling-common.sh`:

```bash
W_STEP=100
H_STEP=50
```

### Add New Tiling Position

Copy an existing tiling script and change the `wmctrl -e` arguments.

### Add New Startup Profile

1. Create `startup/startup-<name>.sh`
2. Source `tiling-common.sh` and `startup-helpers.sh`
3. Launch apps with `&`
4. Call `place` for each window
5. Add case in `startup-profile-switcher.sh`

## Keyboard Shortcuts (Suggested)

Bind these in your window manager or desktop environment:

| Shortcut | Command |
|---|---|
| `Super+Shift+Left` | `quarter/quarter-top-left` |
| `Super+Shift+Right` | `quarter/quarter-top-right` |
| `Super+Ctrl+Left` | `one/one-half-left` |
| `Super+Ctrl+Right` | `one/one-half-right` |
| `Super+Ctrl+Up` | `increase/increase-height` |
| `Super+Ctrl+Down` | `decrease/decrease-height` |
| `Super+Ctrl+Shift+Right` | `increase/increase-width` |
| `Super+Ctrl+Shift+Left` | `decrease/decrease-width` |

## Troubleshooting

### Window jumps to x=0

`wmctrl -e` accepts **signed 16-bit** x-offsets (max 32767). On wide/4K monitors, right-aligned positions that combine large offsets may overflow this limit. When `SW > 1366`, use fraction-based offsets (e.g., `$W_1_2`, `$W_3_4`). Avoid hardcoded values that could exceed 32767.

### Command not found

Install missing dependencies:

```bash
# Debian/Ubuntu
sudo apt install wmctrl xdotool zenity

# Arch
sudo pacman -S wmctrl xdotool zenity

# Fedora
sudo dnf install wmctrl xdotool zenity
```

### Window won't move or resize

Remove maximized state first:

```bash
wmctrl -i -r "$wid" -b remove,maximized_vert,maximized_horiz
```

This is handled automatically by `place()` in startup scripts.

### Gaps around windows

Gap management is delegated to compositor window decorations (gtk.css styling). The `ASIDE_GAP` variable in `tiling-common.sh` is commented out — adjust your compositor shadow/decorations instead.

## Known Limitations

- **Signed 16-bit x-offset limit**: `wmctrl -e` caps x at 32767. Scripts using fraction variables are safe; watch for this when adding new positions on monitors wider than 1366px.
- **No tests, no CI, no build system**: Add new scripts by copying and modifying an existing one.
- **Shebang split**: Most scripts use `#!/bin/bash`; two use `#!/usr/bin/env bash`. Both are supported.
