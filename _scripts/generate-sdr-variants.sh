#!/usr/bin/env bash
# Generate SDR sibling variants of HDR photos in assets/img/news/.
#
# Why: iPhone HDR JPEGs ship with an Apple AMPF gain map. When such an image
# is on a page, macOS/iOS Safari and recent Chrome switch the display to EDR
# mode and dim SDR whites across the entire page so HDR pixels can look
# "brighter than white." We want the page to stay bright (SDR inline thumb)
# but the lightbox to show the full HDR experience.
#
# Convention:
#   assets/img/news/<name>.jpg        ← committed, the HDR original
#   assets/img/news/<name>-sdr.jpg    ← generated, used as inline thumbnail
#
# This script is idempotent: it skips files whose -sdr.jpg already exists
# and is newer than the source. Run locally before `bundle exec jekyll serve`
# or let CI run it before `jekyll build` (see .github/workflows/deploy.yml).

set -euo pipefail

cd "$(dirname "$0")/.."

src_dir="assets/img/news"
quality=88

# Pick an image tool: prefer ImageMagick `magick` (v7), fall back to
# `convert` (v6), then sips on macOS.
if command -v magick >/dev/null 2>&1; then
  tool="magick"
elif command -v convert >/dev/null 2>&1; then
  tool="convert"
elif command -v sips >/dev/null 2>&1; then
  tool="sips"
else
  echo "No image tool found (magick / convert / sips). Skipping."
  exit 0
fi

generated=0
skipped=0
shopt -s nullglob nocaseglob
for src in "$src_dir"/*.{jpg,jpeg}; do
  case "$src" in
    *-sdr.jpg | *-sdr.jpeg) continue ;;
  esac
  base="${src%.*}"
  sdr="${base}-sdr.jpg"
  if [[ -f "$sdr" && "$sdr" -nt "$src" ]]; then
    skipped=$((skipped + 1))
    continue
  fi
  case "$tool" in
    magick)
      magick "$src" -quality "$quality" "$sdr"
      ;;
    convert)
      convert "$src" -quality "$quality" "$sdr"
      ;;
    sips)
      sips -s format jpeg --setProperty formatOptions "$quality" "$src" --out "$sdr" >/dev/null
      ;;
  esac
  generated=$((generated + 1))
  echo "  generated $sdr"
done

echo "SDR variants: ${generated} generated, ${skipped} up to date."
