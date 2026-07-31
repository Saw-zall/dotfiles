#!/usr/bin/env bash
set -euo pipefail

DEBUG_WP_ROTATE=false

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpapers-colors.tsv"

OUT1="${OUT1:-HDMI-A-1}"
OUT2="${OUT2:-DP-1}"
OUT3="${OUT3:-DP-2}"

# Détermine où sont placées les trois teintes cibles autour d'une teinte centrale aléatoire.
SPREAD="${SPREAD:-5}"
if [ "$DEBUG_WP_ROTATE" = true ]; then echo "SPREAD: $SPREAD"; fi

# Détermine combien on accepte de s'éloigner de chaque teinte cible.
TOLERANCE="${TOLERANCE:-15}"
if [ "$DEBUG_WP_ROTATE" = true ]; then echo "TOLERANCE: $TOLERANCE"; fi

# MIN_SAT="${MIN_SAT:-0.20}"
# MIN_LIGHT="${MIN_LIGHT:-0.15}"
# MAX_LIGHT="${MAX_LIGHT:-0.85}"

MIN_SAT="${MIN_SAT:-0.01}"
MIN_LIGHT="${MIN_LIGHT:-0.00}"
MAX_LIGHT="${MAX_LIGHT:-0.99}"

tmp="/tmp/wal-combined.jpg"

pick=$(
  awk -F'\t' \
    -v spread="$SPREAD" \
    -v tol="$TOLERANCE" \
    -v min_sat="$MIN_SAT" \
    -v min_l="$MIN_LIGHT" \
    -v max_l="$MAX_LIGHT" '
  function abs(x){ return x < 0 ? -x : x }
  function hnorm(x){ while (x < 0) x += 360; while (x >= 360) x -= 360; return x }
  function hdist(a,b){ d=abs(a-b); return d>180 ? 360-d : d }

  BEGIN {
    srand()
    center = int(rand() * 360)
    t1 = hnorm(center - spread)
    t2 = center
    t3 = hnorm(center + spread)
  }

  $3 >= min_sat && $4 >= min_l && $4 <= max_l {
    d1 = hdist($2, t1)
    d2 = hdist($2, t2)
    d3 = hdist($2, t3)

    if (d1 <= tol) {
      n1++
      if (rand() < 1/n1) p1=$1
    }

    if (d2 <= tol) {
      n2++
      if (rand() < 1/n2) p2=$1
    }

    if (d3 <= tol) {
      n3++
      if (rand() < 1/n3) p3=$1
    }
  }

  END {
    if (!p1 || !p2 || !p3) exit 2
    if (p1 == p2 || p1 == p3 || p2 == p3) exit 3

    print p1
    print p2
    print p3
  }
' "$CACHE"
)

mapfile -t imgs <<<"$pick"

# Replace pink
# -fuzz 18% -fill "#7b3fbf" -opaque "#ff69b4" \
# -fuzz 18% -fill black -opaque "#ff69b4" \
magick "${imgs[0]}" "${imgs[1]}" "${imgs[2]}" \
  -fuzz 18% -fill black -opaque "#ff69b4" \
  -resize 64x64\! \
  +append \
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
cat ~/.cache/wal/colors-kitty.conf >~/.config/kitty/current-theme.conf
/home/sigill/.local/bin/pywalfox update

printf '%s\n' "${imgs[@]}"
