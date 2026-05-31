#!/usr/bin/env python3
"""Post-process aerospace.toml.src into aerospace.toml, expanding {ws} placeholders."""

import sys
from pathlib import Path

WORKSPACES = [1, 2, 3, 4, 5, 6, 7, 8, 9]

SRC_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.source.toml"
OUT_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"

HEADER = f"""\
# This file is auto-generated from aerospace.source.toml by scripts/gen-workspace-bindings.py.
# Do not edit directly — make changes in aerospace.source.toml instead.
"""


def expand(src: str, workspaces: list) -> str:
    lines = []
    for line in src.splitlines(keepends=True):
        if "{ws}" in line:
            for ws in workspaces:
                lines.append(line.replace("{ws}", str(ws)))
        else:
            lines.append(line)
    return "".join(lines)


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else OUT_PATH
    result = HEADER + "\n" + expand(SRC_PATH.read_text(), WORKSPACES)
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
