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

STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT

stage_one() {
  local skill_dir="$1"
  local name
  local target
  local refs

  name="$(basename "$skill_dir")"
  target="$STAGE_DIR/$name"
  mkdir -p "$target"

  cp "$skill_dir/SKILL.md" "$target/SKILL.md"

  refs="$(grep -Eo '知识库/[^`，。 、)]*\.md' "$skill_dir/SKILL.md" || true)"
  if [ -n "$refs" ]; then
    while IFS= read -r ref; do
      [ -n "$ref" ] || continue
      if [ -f "$ROOT_DIR/$ref" ]; then
        mkdir -p "$target/$(dirname "$ref")"
        cp "$ROOT_DIR/$ref" "$target/$ref"
      fi
    done <<< "$refs"
  fi

  echo "staged $name"
}

for skill_md in "$ROOT_DIR"/skills/*/SKILL.md; do
  stage_one "$(dirname "$skill_md")"
done

python3 - "$STAGE_DIR" "$OUT_DIR/dbskill-${VERSION}.zip" <<'PY'
import os
import sys
import zipfile

stage_dir, archive_path = sys.argv[1], sys.argv[2]

with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for root, _, files in os.walk(stage_dir):
        for filename in files:
            path = os.path.join(root, filename)
            archive.write(path, os.path.relpath(path, stage_dir))
PY

cat > "$OUT_DIR/README.md" <<EOF
# dbskill skill 包

版本：${VERSION}

从 GitHub Releases 下载 dbskill-${VERSION}.zip。zip 的根目录是 17 个 skill 子文件夹，每个子文件夹里有一个标准命名的 SKILL.md（带 YAML frontmatter，含 name + description），并附带该 skill 引用的知识库文件。

格式遵循 Anthropic Skills 规范，可用于 Trae Solo、Claude Code 等支持该格式的产品。整体上传 zip，或拆出需要的子文件夹打包后单独上传都可以。
EOF

echo
echo "done: $OUT_DIR/dbskill-${VERSION}.zip"
