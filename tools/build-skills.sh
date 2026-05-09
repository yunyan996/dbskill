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

build_one() {
  local skill_dir="$1"
  local name
  local work_dir
  local package_path
  local refs

  name="$(basename "$skill_dir")"
  work_dir="$(mktemp -d)"
  package_path="$OUT_DIR/${name}-${VERSION}.skill"

  cp "$skill_dir/SKILL.md" "$work_dir/SKILL.md"

  refs="$(grep -Eo '知识库/[^`，。 、)]*\.md' "$skill_dir/SKILL.md" || true)"
  if [ -n "$refs" ]; then
    while IFS= read -r ref; do
      [ -n "$ref" ] || continue
      if [ -f "$ROOT_DIR/$ref" ]; then
        mkdir -p "$work_dir/$(dirname "$ref")"
        cp "$ROOT_DIR/$ref" "$work_dir/$ref"
      fi
    done <<< "$refs"
  fi

  python3 - "$work_dir" "$package_path" <<'PY'
import os
import sys
import zipfile

source_dir, package_path = sys.argv[1], sys.argv[2]

with zipfile.ZipFile(package_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for root, _, files in os.walk(source_dir):
        for filename in files:
            path = os.path.join(root, filename)
            archive.write(path, os.path.relpath(path, source_dir))
PY

  rm -rf "$work_dir"
  echo "built $(basename "$package_path")"
}

for skill_md in "$ROOT_DIR"/skills/*/SKILL.md; do
  build_one "$(dirname "$skill_md")"
done

python3 - "$OUT_DIR" "dbskill-${VERSION}.zip" <<'PY'
import os
import sys
import zipfile

out_dir, archive_name = sys.argv[1], sys.argv[2]
archive_path = os.path.join(out_dir, archive_name)

with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for filename in sorted(os.listdir(out_dir)):
        if filename.endswith(".skill"):
            archive.write(os.path.join(out_dir, filename), filename)
PY

cat > "$OUT_DIR/README.md" <<EOF
# dbskill skill 包

版本：${VERSION}

从 GitHub Releases 下载 dbskill-${VERSION}.zip 解压后，里面是 17 个 .skill 文件。每个 .skill 是一个 zip，根目录是 SKILL.md（带 YAML frontmatter，含 name + description），并自动带上该 skill 引用的知识库文件。

格式遵循 Anthropic Skills 规范，可用于 Trae Solo、Claude Code 等支持该格式的产品。把 .skill 逐个上传即可。
EOF

echo
echo "done: $OUT_DIR"
