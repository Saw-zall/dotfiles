#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/wal"
default_input="$cache_dir/colors-hyprland"
fallback_input="$HOME/.config/hypr/colors-hyprland"

input="${1:-$default_input}"
output="${2:-$cache_dir/colors-hyprland.lua}"

if [[ ! -f "$input" ]]; then
  if [[ -f "$fallback_input" ]]; then
    input="$fallback_input"
  else
    echo "pywal-to-hyprlua: no colors-hyprland file found" >&2
    exit 0
  fi
fi

mkdir -p "$(dirname "$output")"

{
  echo "-- Auto-generated from $input"
  echo "return {"

  while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$line" ]] && continue
    [[ "$line" == \#* ]] && continue

    if [[ "$line" =~ ^\$([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=[[:space:]]*(.+)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
      value="${value%"${value##*[![:space:]]}"}"
      value="${value//\\/\\\\}"
      value="${value//\"/\\\"}"
      printf '  %s = "%s",\n' "$key" "$value"
    fi
  done < "$input"

  echo "}"
} > "$output"
