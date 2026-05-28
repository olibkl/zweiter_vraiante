#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$ROOT_DIR/raw"
ORGANIZED_DIR="$ROOT_DIR/organized"

if [[ ! -d "$RAW_DIR/Planning" ]]; then
  echo "Expected source folder not found: $RAW_DIR/Planning" >&2
  exit 1
fi

rm -rf "$ORGANIZED_DIR"
mkdir -p "$ORGANIZED_DIR"

find "$RAW_DIR" -type f -name '*.al' | sort | while IFS= read -r file_path; do
  domain="core-planning"

  case "$file_path" in
    */raw/Planning/scenario/*)
      domain="scenario"
      ;;
    */raw/Planning/fashion-statistic/*)
      domain="fashion-statistic"
      ;;
  esac

  filename="$(basename "$file_path")"
  object_token="${filename%.al}"
  object_token="${object_token##*.}"

  case "$object_token" in
    Codeunit) type_dir="codeunits" ;;
    Page) type_dir="pages" ;;
    Table) type_dir="tables" ;;
    Query) type_dir="queries" ;;
    Report) type_dir="reports" ;;
    Enum) type_dir="enums" ;;
    Xmlport) type_dir="xmlports" ;;
    *) type_dir="misc" ;;
  esac

  target_dir="$ORGANIZED_DIR/$domain/$type_dir"
  mkdir -p "$target_dir"
  cp "$file_path" "$target_dir/$filename"
done

echo "Rebuilt organized structure in: $ORGANIZED_DIR"
