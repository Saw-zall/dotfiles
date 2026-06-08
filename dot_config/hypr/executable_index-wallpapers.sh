#!/usr/bin/env bash
set -euo pipefail

# DIR="${1:-$HOME/wallpapers}"
DIR="${1:-/media/sigill/data/Pictures/WP}"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpapers-colors.tsv"

mkdir -p "$(dirname "$CACHE")"
: > "$CACHE"

find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) |
while IFS= read -r img; do
  rgb=$(magick "$img" -resize 1x1\! -format "%[fx:int(255*r)],%[fx:int(255*g)],%[fx:int(255*b)]" info: 2>/dev/null) || continue

  awk -v path="$img" -v rgb="$rgb" '
    function max(a,b,c){ return a>b ? (a>c?a:c) : (b>c?b:c) }
    function min(a,b,c){ return a<b ? (a<c?a:c) : (b<c?b:c) }
    BEGIN {
      split(rgb, c, ",")
      r=c[1]/255; g=c[2]/255; b=c[3]/255
      mx=max(r,g,b); mn=min(r,g,b)
      d=mx-mn
      l=(mx+mn)/2

      if (d == 0) h=0
      else if (mx == r) h=60 * (((g-b)/d) % 6)
      else if (mx == g) h=60 * (((b-r)/d) + 2)
      else h=60 * (((r-g)/d) + 4)

      if (h < 0) h += 360
      s = d == 0 ? 0 : d / (1 - sqrt((2*l-1)^2))

      printf "%s\t%.2f\t%.4f\t%.4f\n", path, h, s, l
    }
  ' >> "$CACHE"
done

echo "Cache updated : $CACHE"
