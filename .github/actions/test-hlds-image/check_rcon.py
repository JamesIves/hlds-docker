#!/usr/bin/env python3
"""Performs a real RCON round-trip against a running GoldSrc server.

GoldSrc RCON is UDP-based challenge/response (not the TCP protocol used by
newer Source games). A successful exchange proves the engine has finished
initializing its console and command systems, not just that the process
is alive and answering basic queries.
"""

import re
import socket
import sys

HOST = "127.0.0.1"
PORT = 27015
PASSWORD = "changeme"
TIMEOUT_SECONDS = 10


def send_and_receive(sock: socket.socket, payload: bytes) -> bytes:
    sock.sendto(payload, (HOST, PORT))
    data, _ = sock.recvfrom(4096)
    return data


def main() -> int:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(TIMEOUT_SECONDS)
    try:
        challenge_response = send_and_receive(sock, b"\xff\xff\xff\xffchallenge rcon\n")
    except socket.timeout:
        print("Timed out waiting for an RCON challenge response.")
        return 1

    match = re.search(rb"challenge rcon (\d+)", challenge_response)
    if not match:
        print(f"Failed to parse RCON challenge from response: {challenge_response!r}")
        return 1
    challenge = match.group(1).decode()

    command = f"rcon {challenge} {PASSWORD} stats".encode()
    try:
        rcon_response = send_and_receive(sock, b"\xff\xff\xff\xff" + command + b"\n")
    except socket.timeout:
        print("Timed out waiting for an RCON command response.")
        return 1
    finally:
        sock.close()

    if not rcon_response.startswith(b"\xff\xff\xff\xffl"):
        print(f"Unexpected RCON response: {rcon_response!r}")
        return 1

    print(f"RCON response: {rcon_response[5:].decode(errors='replace').strip()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
