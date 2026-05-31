#!/usr/bin/env python3
"""Post-process aerospace.source.toml into aerospace.toml, expanding placeholders.

Expansion config is read from the [generator] table at the top of
aerospace.source.toml. Root-level aerospace keys live under [aerospace] to
keep the source file valid TOML throughout. Both sections are stripped from
the generated output: [generator] is removed entirely and [aerospace] has
its header dropped so its keys become root-level.

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


def process(src: str, workspaces: list, directions: list) -> str:
    lines = src.splitlines(keepends=True)
    result = []
    in_generator = False
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if stripped == "[generator]":
            in_generator = True
            i += 1
            continue

        if in_generator:
            if stripped.startswith("["):
                in_generator = False
                # fall through to process this line
            else:
                i += 1
                continue

        if stripped == "[aerospace]":
            i += 1
            continue

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


def parse_generator(src: str) -> dict:
    """Extract and parse only the [generator] block, avoiding placeholder lines."""
    lines = src.splitlines(keepends=True)
    block = []
    in_generator = False
    for line in lines:
        if line.strip() == "[generator]":
            in_generator = True
            block.append(line)
            continue
        if in_generator:
            if line.strip().startswith("["):
                break
            block.append(line)
    return tomllib.loads("".join(block))["generator"]


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else OUT_PATH
    src = SRC_PATH.read_text()
    config = parse_generator(src)
    workspaces = config["workspaces"]
    directions = [tuple(pair) for pair in config["directions"]]
    result = HEADER + "\n" + process(src, workspaces, directions)
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
