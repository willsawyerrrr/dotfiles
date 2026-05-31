#!/usr/bin/env python3
"""Post-process aerospace.source.toml into aerospace.toml.

Parses the source file as TOML, expands template keys using the [generator]
config, removes the [generator] and [aerospace] wrapper sections, and
serialises the result. Comments are not preserved in the output — they live
in the source file.
"""

import sys
import tomllib
from pathlib import Path
from typing import Any

SRC_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.source.toml"
OUT_PATH = Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"

HEADER = """\
# This file is auto-generated from aerospace.source.toml by scripts/gen-aerospace-config.py.
# Do not edit directly — make changes in aerospace.source.toml instead.
"""


def expand_value(value: Any, replacements: dict[str, str]) -> Any:
    """Recursively apply string replacements to a value.

    Traverses strings and lists; anything else is returned unchanged.
    """
    if isinstance(value, str):
        for old, new in replacements.items():
            value = value.replace(old, new)
        return value
    if isinstance(value, list):
        return [expand_value(v, replacements) for v in value]
    return value


def expand_templates(data: dict, workspaces: list, directions: dict) -> dict:
    """Recursively expand template keys throughout a parsed TOML dict.

    Keys containing {ws} are expanded once per workspace; keys containing
    {dir_key} are expanded once per direction, with {dir} also replaced in
    the corresponding value. All other keys and values are passed through
    unchanged. Sub-tables and arrays of tables are recursed into.
    """
    result = {}
    for key, value in data.items():
        if isinstance(value, dict):
            result[key] = expand_templates(value, workspaces, directions)
        elif is_table_array(value):
            result[key] = [expand_templates(item, workspaces, directions) for item in value]
        elif "{ws}" in key:
            for ws in workspaces:
                result[key.replace("{ws}", str(ws))] = expand_value(value, {"{ws}": str(ws)})
        elif "{dir_key}" in key:
            for dir_key, dir_name in directions.items():
                repl = {"{dir_key}": dir_key, "{dir}": dir_name}
                result[key.replace("{dir_key}", dir_key)] = expand_value(value, repl)
        else:
            result[key] = value
    return result


def is_table_array(value: Any) -> bool:
    """Return True if value is a non-empty list whose every element is a dict.

    This corresponds to a TOML array of tables ([[section]]).
    """
    return isinstance(value, list) and bool(value) and all(isinstance(v, dict) for v in value)


def quote_str(s: str) -> str:
    """Wrap a string in TOML basic-string quotes with minimal escaping."""
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def flatten_dict(key: str, value: Any) -> list[tuple[str, Any]]:
    """Flatten nested dicts into dotted-key pairs for inline table serialisation."""
    if isinstance(value, dict):
        result = []
        for k, v in value.items():
            result.extend(flatten_dict(f"{key}.{k}", v))
        return result
    return [(key, value)]


def serialize_inline(value: Any) -> str:
    """Serialise a value as a TOML inline expression.

    Dicts are written as inline tables using dotted-key notation for any
    nested dicts, matching the source file's per-monitor gap syntax.
    """
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, str):
        return quote_str(value)
    if isinstance(value, list):
        return "[" + ", ".join(serialize_inline(v) for v in value) + "]"
    if isinstance(value, dict):
        parts = []
        for k, v in value.items():
            for fk, fv in flatten_dict(k, v):
                parts.append(f"{fk} = {serialize_inline(fv)}")
        return "{" + ", ".join(parts) + "}"
    return str(value)


def serialize(data: dict, path: str = "") -> list[str]:
    """Serialise a dict to TOML lines, recursing into sub-tables.

    Scalars and arrays are emitted first as bare key-value pairs, then
    sub-tables as [section] blocks (omitting the header when the table has
    no direct values, letting the deeper sub-section headers suffice), then
    arrays of tables as [[section]] blocks with dotted keys for any nested
    dicts within each item.
    """
    lines = []

    for key, value in data.items():
        if not isinstance(value, dict) and not is_table_array(value):
            lines.append(f"{key} = {serialize_inline(value)}")

    for key, value in data.items():
        if isinstance(value, dict):
            subpath = f"{path}.{key}" if path else key
            sub_lines = serialize(value, subpath)
            # Only emit a section header if this level has direct key-value pairs;
            # otherwise the sub-section headers are sufficient.
            has_direct_values = any(
                not isinstance(v, dict) and not is_table_array(v)
                for v in value.values()
            )
            if has_direct_values:
                lines.append(f"\n[{subpath}]")
            lines.extend(sub_lines)

    for key, value in data.items():
        if is_table_array(value):
            subpath = f"{path}.{key}" if path else key
            for item in value:
                lines.append(f"\n[[{subpath}]]")
                for item_key, item_val in item.items():
                    for flat_key, flat_val in flatten_dict(item_key, item_val):
                        lines.append(f"{flat_key} = {serialize_inline(flat_val)}")

    return lines


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else OUT_PATH

    src = SRC_PATH.read_text()
    data = tomllib.loads(src)

    generator = data.pop("generator")
    workspace_monitors = dict(generator["workspace-monitors"])
    workspaces = list(workspace_monitors.keys())
    directions = dict(generator["directions"])

    data.update(data.pop("aerospace"))
    data["workspace-to-monitor-force-assignment"] = workspace_monitors
    data["on-window-detected"] = [
        {"if": {"app-id": app_id}, "run": f"move-node-to-workspace {ws}"}
        for app_id, ws in generator["workspace-apps"].items()
    ]
    data = expand_templates(data, workspaces, directions)

    output_path.write_text(HEADER + "\n" + "\n".join(serialize(data)) + "\n")
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
