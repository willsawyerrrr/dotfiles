#!/usr/bin/env python3
"""Generate AeroSpace workspace bindings and inject them into aerospace.toml."""

import sys
from pathlib import Path

WORKSPACES = [1, 2, 3, 4, 5, 6, 7, 8, 9]

TOML_PATH = (
    Path(__file__).parent.parent / "dot-config" / "aerospace" / "aerospace.toml"
)

_HASHES = "#" * 40
BEGIN = f"{_HASHES}\n# BEGIN GENERATED: workspace-bindings\n{_HASHES}"
END = f"{_HASHES}\n# END GENERATED: workspace-bindings\n{_HASHES}"


def generate(workspaces: list) -> str:
    switch = [f'alt-{ws} = "workspace {ws}"' for ws in workspaces]
    move = [
        f'alt-shift-{ws} = ["move-node-to-workspace {ws}", '
        f'"exec-and-forget sketchybar --trigger aerospace_window_moved DESTINATION_WORKSPACE={ws}"]'
        for ws in workspaces
    ]
    return (
        "# See: https://nikitabobko.github.io/AeroSpace/commands#workspace\n"
        + "\n".join(switch)
        + "\n\n"
        + "# See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace\n"
        + "\n".join(move)
    )


def inject(content: str, generated: str) -> str:
    begin_idx = content.find(BEGIN)
    end_idx = content.find(END)
    if begin_idx == -1 or end_idx == -1:
        raise ValueError(f"Markers not found in config — expected '{BEGIN}' and '{END}'")
    return content[: begin_idx] + BEGIN + "\n\n" + generated + "\n\n" + END + content[end_idx + len(END) :]


def main() -> None:
    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else TOML_PATH
    content = TOML_PATH.read_text()
    result = inject(content, generate(WORKSPACES))
    output_path.write_text(result)
    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
