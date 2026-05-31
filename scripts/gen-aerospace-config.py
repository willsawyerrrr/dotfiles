#!/usr/bin/env python3
"""Post-process aerospace.source.toml into aerospace.toml, expanding placeholders.

Placeholders:
  {ws}       — expanded once per workspace (e.g. 1, 2, 3 ...)
  {dir_key}  — expanded once per direction key (h, j, k, l)
  {dir}      — expanded once per direction name (left, down, up, right)

{dir_key} and {dir} are always expanded together as a pair.
Multi-line TOML arrays whose opening line contains a direction placeholder
are expanded as a complete block rather than line-by-line.
"""

import sys
from pathlib import Path

WORKSPACES = [1, 2, 3, 4, 5, 6, 7, 8, 9]
DIRECTIONS = [("h", "left"), ("j", "down"), ("k", "up"), ("l", "right")]

SRC_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.source.toml"
OUT_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"

HEADER = """\
# This file is auto-generated from aerospace.source.toml by scripts/gen-aerospace-config.py.
# Do not edit directly — make changes in aerospace.source.toml instead.
"""


def expand(src: str, workspaces: list, directions: list) -> str:
    lines = src.splitlines(keepends=True)
    result = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if "{ws}" in line:
            for ws in workspaces:
                result.append(line.replace("{ws}", str(ws)))
            i += 1
        elif "{dir" in line:
            if line.rstrip().endswith("["):
                # Collect the entire multi-line array block, then expand it as a unit
                block = [line]
                i += 1
                while i < len(lines) and lines[i].strip() != "]":
                    block.append(lines[i])
                    i += 1
                if i < len(lines):
                    block.append(lines[i])
                    i += 1
                block_str = "".join(block)
                for key, direction in directions:
                    result.append(block_str.replace("{dir_key}", key).replace("{dir}", direction))
            else:
                for key, direction in directions:
                    result.append(line.replace("{dir_key}", key).replace("{dir}", direction))
                i += 1
        else:
            result.append(line)
            i += 1
    return "".join(result)


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else OUT_PATH
    result = HEADER + "\n" + expand(SRC_PATH.read_text(), WORKSPACES, DIRECTIONS)
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
