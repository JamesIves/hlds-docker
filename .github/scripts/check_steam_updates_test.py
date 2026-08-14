#!/usr/bin/env python3
"""Asserts the parser extracts valid branch timestamps; fails loudly (unlike production's fail-safe) so CI catches regressions."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import check_steam_updates as checker  # noqa: E402

FIXTURE = Path(__file__).parent / "testdata" / "app_info_sample.txt"


def assert_parses(app_info_path: str) -> None:
    timestamps = checker.branch_timestamps(app_info_path)

    missing = [b for b in checker.RELEVANT_BRANCHES if b not in timestamps]
    if missing:
        raise AssertionError(f"missing expected branch(es) {missing} - got {list(timestamps)}")

    for branch, ts in timestamps.items():
        if ts <= 0:
            raise AssertionError(f"branch '{branch}' has a non-positive timestamp: {ts}")

    print(f"OK: parsed {timestamps} from {app_info_path}")


def main() -> int:
    app_info_path = sys.argv[1] if len(sys.argv) > 1 else str(FIXTURE)
    try:
        assert_parses(app_info_path)
    except Exception as exc:
        print(f"FAIL: {exc}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
