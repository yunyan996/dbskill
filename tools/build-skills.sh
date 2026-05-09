#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-"$ROOT_DIR/dist/skills"}"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 command is required" >&2
  exit 1
fi

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

INNER_DIR="$(mktemp -d)"
trap 'rm -rf "$INNER_DIR"' EXIT

build_one() {
  local skill_dir="$1"
  local name
  local stage_dir
  local refs

  name="$(basename "$skill_dir")"
  stage_dir="$(mktemp -d)"

  cp "$skill_dir/SKILL.md" "$stage_dir/SKILL.md"

  refs="$(grep -Eo '知识库/[^`,。 、)]*\.md' "$skill_dir/SKILL.md" || true)"
  if [ -n "$refs" ]; then
    while IFS= read -r ref; do
      [ -n "$ref" ] || continue
      if [ -f "$ROOT_DIR/$ref" ]; then
        mkdir -p "$stage_dir/$(dirname "$ref")"
        cp "$ROOT_DIR/$ref" "$stage_dir/$ref"
      fi
    done <<< "$refs"
  fi

  python3 - "$stage_dir" "$INNER_DIR/${name}.zip" <<'PY'
import os
import sys
import zipfile

source_dir, archive_path = sys.argv[1], sys.argv[2]

with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for root, _, files in os.walk(source_dir):
        for filename in files:
            path = os.path.join(root, filename)
            archive.write(path, os.path.relpath(path, source_dir))
PY

  rm -rf "$stage_dir"
  echo "built ${name}.zip"
}

for skill_md in "$ROOT_DIR"/skills/*/SKILL.md; do
  build_one "$(dirname "$skill_md")"
done

cat > "$INNER_DIR/README.md" <<EOF
# dbskill ${VERSION}

里面是 17 个独立的 skill zip 包。每个 zip 解压后根目录是 SKILL.md（带 YAML frontmatter，含 name + description），并附带该 skill 引用的知识库文件。

格式遵循 Anthropic Skills 规范，可用于 Trae Solo、Claude Code 等支持该格式的产品。逐个上传到 Trae Solo 的「上传技能」窗口即可。
EOF

python3 - "$INNER_DIR" "$OUT_DIR/dbskill-${VERSION}.zip" <<'PY'
import os
import sys
import zipfile

inner_dir, archive_path = sys.argv[1], sys.argv[2]

with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for filename in sorted(os.listdir(inner_dir)):
        archive.write(os.path.join(inner_dir, filename), filename)
PY

echo
echo "done: $OUT_DIR/dbskill-${VERSION}.zip"
