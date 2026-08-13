#!/usr/bin/env bash

# Confirms the server answers a raw A2S_INFO query over UDP, the same query
# Steam's server browser and check_a2s_info.py use to determine liveness.
# Uses bash's built-in /dev/udp so no extra dependencies (netcat, python) are
# needed in the runtime image.

PORT="${PORT:-27015}"
[[ "$PORT" =~ ^[0-9]+$ ]] || PORT=27015

# A single read of the datagram is required: UDP sockets hand back one
# datagram per read(), so asking for it in small chunks (e.g. `dd bs=1`)
# discards the rest of the packet after the first chunk and hangs waiting
# for a second datagram that will never arrive.
RESPONSE_HEX=$(timeout 3 bash -c "
  exec 3<>/dev/udp/127.0.0.1/$PORT || exit 1
  printf '\xff\xff\xff\xffTSource Engine Query\x00' >&3
  dd bs=4096 count=1 <&3 2>/dev/null | head -c 4 | od -An -tx1 | tr -d ' \n'
")

[ "$RESPONSE_HEX" = "ffffffff" ]
