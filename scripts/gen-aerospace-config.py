#!/usr/bin/env python3
"""Post-process aerospace.source.toml into aerospace.toml, expanding placeholders.

Expansion config is defined at the top of aerospace.source.toml in a commented-out
TOML block (so the source file remains valid TOML throughout):

  # [generator]
  # workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  # directions = [["h", "left"], ["j", "down"], ["k", "up"], ["l", "right"]]

Placeholders:
  {ws}       — expanded once per workspace
  {dir_key}  — expanded once per direction key (e.g. h, j, k, l)
  {dir}      — expanded once per direction name (e.g. left, down, up, right)

{dir_key} and {dir} are always expanded together as a pair.
Multi-line TOML arrays whose opening line contains a direction placeholder
are expanded as a complete block rather than line-by-line.
"""

import sys
import tomllib
from pathlib import Path

SRC_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.source.toml"
OUT_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"

HEADER = """\
# This file is auto-generated from aerospace.source.toml by scripts/gen-aerospace-config.py.
# Do not edit directly — make changes in aerospace.source.toml instead.
"""


def parse_generator_block(lines: list[str]) -> tuple[dict, int]:
    """Parse the leading commented-out [generator] TOML block.

    Returns the parsed config dict and the number of lines consumed
    (including the trailing blank line, if present).
    """
    block = []
    i = 0
    while i < len(lines) and lines[i].startswith("#"):
        block.append(lines[i][2:] if lines[i].startswith("# ") else lines[i][1:])
        i += 1
    if i < len(lines) and lines[i].strip() == "":
        i += 1  # consume the blank line separating block from config
    return tomllib.loads("".join(block)), i


def expand(lines: list[str], workspaces: list, directions: list) -> str:
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
    lines = SRC_PATH.read_text().splitlines(keepends=True)
    config, body_start = parse_generator_block(lines)
    workspaces = config["generator"]["workspaces"]
    directions = [tuple(pair) for pair in config["generator"]["directions"]]
    result = HEADER + "\n" + expand(lines[body_start:], workspaces, directions)
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
