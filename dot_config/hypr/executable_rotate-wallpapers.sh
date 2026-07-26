#!/usr/bin/env bash
set -euo pipefail

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpapers-colors.tsv"

OUT1="${OUT1:-HDMI-A-1}"
OUT2="${OUT2:-DP-1}"
OUT3="${OUT3:-DP-2}"

TOLERANCE="${TOLERANCE:-25}"
MIN_SAT="${MIN_SAT:-0.20}"
MIN_LIGHT="${MIN_LIGHT:-0.15}"
MAX_LIGHT="${MAX_LIGHT:-0.85}"

tmp="/tmp/wal-combined.jpg"

pick=$(
awk -F'\t' \
  -v tol="$TOLERANCE" \
  -v min_sat="$MIN_SAT" \
  -v min_l="$MIN_LIGHT" \
  -v max_l="$MAX_LIGHT" '
  function abs(x){ return x < 0 ? -x : x }
  function hdist(a,b){
    d = abs(a-b)
    return d > 180 ? 360-d : d
  }
  function target(h, add){
    return (h + add) % 360
  }

  $3 >= min_sat && $4 >= min_l && $4 <= max_l {
    n++
    path[n]=$1
    hue[n]=$2
  }

  END {
    srand()

    if (n < 3) exit 1

    for (tries=0; tries<500; tries++) {
      a = int(rand() * n) + 1
      h1 = hue[a]

      nb = 0
      nc = 0

      for (i=1; i<=n; i++) {
        if (i == a) continue

        db = hdist(hue[i], target(h1, 120))
        dc = hdist(hue[i], target(h1, 240))

        if (db <= tol) {
          nb++
          b[nb] = i
        }

        if (dc <= tol) {
          nc++
          c[nc] = i
        }
      }

      if (nb > 0 && nc > 0) {
        bi = b[int(rand() * nb) + 1]
        ci = c[int(rand() * nc) + 1]

        if (bi != ci && bi != a && ci != a) {
          print path[a]
          print path[bi]
          print path[ci]
          exit
        }
      }
    }

    exit 2
  }
' "$CACHE"
)

mapfile -t imgs <<< "$pick"

montage "${imgs[0]}" "${imgs[1]}" "${imgs[2]}" \
  -resize 64x64\! \
  -background none \
  -geometry +0+0 \
  -tile 3x1 \
  "$tmp"

wal -i "$tmp" -q -n
bash ~/.config/hypr/pywal-to-hyprlua.sh
hyprctl reload

awww img "${imgs[0]}" --outputs "$OUT1"
awww img "${imgs[1]}" --outputs "$OUT2"
awww img "${imgs[2]}" --outputs "$OUT3"

# pkill swayosd-server
# swayosd-server &
swaync-client --reload-css
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
/home/sigill/.local/bin/pywalfox update

printf '%s\n' "${imgs[@]}"
