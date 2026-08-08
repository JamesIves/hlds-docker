#!/usr/bin/env python3
"""Polls a GoldSrc server for a valid A2S_INFO response.

Used two ways:
  - By default, confirms the engine has finished booting and is answering
    the real query protocol on its UDP port, rather than just checking that
    setup files were copied into place before the engine was ever started.
  - With --expect-no-response, confirms a server that was intentionally
    given bad configuration (e.g. an unsupported GAME value) fails
    observably instead of silently reporting itself as healthy.
"""

import argparse
import socket
import sys
import time

QUERY = b"\xff\xff\xff\xffTSource Engine Query\x00"


def poll_for_response(host: str, port: int, timeout_seconds: int, poll_interval: int) -> bytes:
    deadline = time.monotonic() + timeout_seconds
    last_error = "no attempts made"

    while time.monotonic() < deadline:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(3)
        try:
            sock.sendto(QUERY, (host, port))
            data, _ = sock.recvfrom(4096)
            if data[:4] == b"\xff\xff\xff\xff" and len(data) > 5:
                return data
            last_error = f"unexpected response: {data!r}"
        except socket.timeout:
            last_error = "timed out waiting for a response"
        except OSError as exc:
            last_error = str(exc)
        finally:
            sock.close()
        time.sleep(poll_interval)

    raise TimeoutError(last_error)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=27015)
    parser.add_argument("--timeout", type=int, default=90, help="Seconds to poll before giving up.")
    parser.add_argument("--poll-interval", type=int, default=2)
    parser.add_argument(
        "--expect-no-response",
        action="store_true",
        help="Succeed only if the server does NOT answer within the timeout.",
    )
    args = parser.parse_args()

    try:
        data = poll_for_response(args.host, args.port, args.timeout, args.poll_interval)
    except TimeoutError as exc:
        if args.expect_no_response:
            print(f"Confirmed no A2S_INFO response was received, as expected: {exc}")
            return 0
        print(f"No valid A2S_INFO response received within {args.timeout}s: {exc}")
        return 1

    if args.expect_no_response:
        print(f"Server answered A2S_INFO ({len(data)} bytes) when it was expected to fail to start!")
        return 1

    print(f"A2S_INFO response received ({len(data)} bytes), response type byte: {hex(data[4])}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
