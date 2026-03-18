#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

build_one() {
  local input="$1"

  if [[ ! -f "$input" ]]; then
    echo "Skipping (not found): $input" >&2
    return 0
  fi

  if [[ "${input##*.}" != "mmd" ]]; then
    echo "Skipping (not .mmd): $input" >&2
    return 0
  fi

  local output_pdf="${input%.mmd}.pdf"
  local output_svg="${input%.mmd}.svg"

  echo "Building Mermaid diagram: $input"
  npx -y @mermaid-js/mermaid-cli@11.4.2 -i "$input" -o "$output_pdf" -b transparent
  npx -y @mermaid-js/mermaid-cli@11.4.2 -i "$input" -o "$output_svg" -b transparent
}

main() {
  cd "$ROOT_DIR"

  if [[ "$#" -gt 0 ]]; then
    for file in "$@"; do
      build_one "$file"
    done
  else
    while IFS= read -r -d '' file; do
      build_one "$file"
    done < <(find . -type f -name "*.mmd" -print0)
  fi

  echo "Done building Mermaid diagrams."
}

main "$@"
