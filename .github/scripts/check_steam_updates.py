#!/usr/bin/env python3
"""Decides whether the scheduled release has anything new to publish.

Compares Steam's last-updated timestamp for HLDS (app 90)'s relevant
branches against the last GitHub release's publish time. Writes
changed=true/false to $GITHUB_OUTPUT so the workflow can skip an entire
rebuild-and-republish cycle when nothing changed upstream.
"""

import os
import re
import subprocess
import sys
from datetime import datetime, timezone

APP_ID = "90"
# "public" backs the modern (non -legacy) images, "steam_legacy" backs the
# *-legacy images pinned to the pre-25th-anniversary build.
RELEVANT_BRANCHES = ["public", "steam_legacy"]

TOKEN_RE = re.compile(r'"((?:[^"\\]|\\.)*)"|(\{)|(\})')


def tokenize(text: str) -> list:
    return TOKEN_RE.findall(text)


def parse_kv(tokens: list, pos: int = 0) -> tuple:
    """Minimal recursive-descent parser for Valve's KeyValues (VDF) text
    format - just enough to walk the nested "key" { ... } blocks that
    app_info_print emits, without pulling in a third-party dependency."""
    result = {}
    while pos < len(tokens):
        key, open_brace, close_brace = tokens[pos]
        pos += 1
        if close_brace:
            return result, pos

        nxt_key, nxt_open, _ = tokens[pos]
        if nxt_open:
            pos += 1
            value, pos = parse_kv(tokens, pos)
        else:
            value = nxt_key
            pos += 1
        result[key] = value
    return result, pos


def branch_timestamps(app_info_path: str) -> dict:
    with open(app_info_path) as f:
        text = f.read()

    # app_info_print's output has SteamCMD log lines before the VDF block -
    # the block itself starts at the appid key.
    start = text.find(f'"{APP_ID}"')
    if start == -1:
        raise ValueError("could not find app info block in SteamCMD output")

    root, _ = parse_kv(tokenize(text[start:]))
    branches = root[APP_ID]["depots"]["branches"]

    timestamps = {}
    for name in RELEVANT_BRANCHES:
        branch = branches.get(name)
        if branch and "timeupdated" in branch:
            timestamps[name] = int(branch["timeupdated"])
    return timestamps


def last_release_timestamp():
    result = subprocess.run(
        ["gh", "release", "view", "--json", "publishedAt", "--jq", ".publishedAt"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0 or not result.stdout.strip():
        return None
    published_at = datetime.fromisoformat(result.stdout.strip().replace("Z", "+00:00"))
    return int(published_at.timestamp())


def write_output(changed: bool) -> None:
    value = "true" if changed else "false"
    print(f"changed={value}")
    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a") as f:
            f.write(f"changed={value}\n")


def main() -> int:
    app_info_path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/app_info.txt"

    try:
        timestamps = branch_timestamps(app_info_path)
        if not timestamps:
            raise ValueError("none of the expected branches were present")

        for branch, ts in timestamps.items():
            print(f"Branch '{branch}' last updated: {datetime.fromtimestamp(ts, tz=timezone.utc)}")

        last_release = last_release_timestamp()
        if last_release is None:
            print("No prior release found; publishing.")
            changed = True
        else:
            print(f"Last release published: {datetime.fromtimestamp(last_release, tz=timezone.utc)}")
            changed = max(timestamps.values()) > last_release
    except Exception as exc:
        print(f"::warning::Could not determine whether Steam has updates ({exc}); publishing to be safe.")
        changed = True

    write_output(changed)
    return 0


if __name__ == "__main__":
    sys.exit(main())
