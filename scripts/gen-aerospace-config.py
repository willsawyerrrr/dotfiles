#!/usr/bin/env python3
"""Post-process aerospace.source.toml into aerospace.toml.

The source file is valid TOML throughout. Template lines use quoted keys
containing placeholders, e.g. "alt-{ws}" = "workspace {ws}". Placeholders:
  {ws}      — expanded once per workspace
  {dir_key} — expanded once per direction key (h, j, k, l)
  {dir}     — expanded once per direction name (left, down, up, right)

{dir_key} and {dir} are always expanded together as a pair. Multi-line
TOML arrays are collected and expanded as a complete block. Quoted keys are
unquoted after expansion since the results are valid bare TOML keys.

The [generator] section is stripped from the output and the [aerospace]
header is dropped so its keys become root-level in the generated file.
"""

import re
import sys
import tomllib
from pathlib import Path

SRC_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.source.toml"
OUT_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"

HEADER = """\
# This file is auto-generated from aerospace.source.toml by scripts/gen-aerospace-config.py.
# Do not edit directly — make changes in aerospace.source.toml instead.
"""

_QUOTED_KEY_RE = re.compile(r'^"([^"]+)"(\s*=)')


def unquote_key(line: str) -> str:
    return _QUOTED_KEY_RE.sub(r'\1\2', line)


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
                in_generator = False  # fall through to process this line
            else:
                i += 1
                continue

        if stripped == "[aerospace]":
            i += 1
            continue

        if "{ws}" in line:
            for ws in workspaces:
                result.append(unquote_key(line.replace("{ws}", str(ws))))
            i += 1
        elif "{dir" in line:
            if line.rstrip().endswith("["):
                block = [line]
                i += 1
                while i < len(lines) and lines[i].strip() != "]":
                    block.append(lines[i])
                    i += 1
                if i < len(lines):
                    block.append(lines[i])
                    i += 1
                for key, direction in directions:
                    exp = [l.replace("{dir_key}", key).replace("{dir}", direction) for l in block]
                    exp[0] = unquote_key(exp[0])
                    result.extend(exp)
            else:
                for key, direction in directions:
                    result.append(unquote_key(line.replace("{dir_key}", key).replace("{dir}", direction)))
                i += 1
        else:
            result.append(line)
            i += 1

    return "".join(result)


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else OUT_PATH
    src = SRC_PATH.read_text()
    generator = tomllib.loads(src)["generator"]
    workspaces = generator["workspaces"]
    directions = list(generator["directions"].items())
    result = HEADER + "\n" + process(src, workspaces, directions)
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
