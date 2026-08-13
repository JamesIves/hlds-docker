#!/usr/bin/env bash

# Polls the server with a raw A2S_INFO UDP query via bash's /dev/udp, avoiding extra deps.

PORT="${PORT:-27015}"
[[ "$PORT" =~ ^[0-9]+$ ]] || PORT=27015

# One read only - UDP hands back a full datagram per read(), so small reads lose the rest and hang.
RESPONSE_HEX=$(timeout 3 bash -c "
  exec 3<>/dev/udp/127.0.0.1/$PORT || exit 1
  printf '\xff\xff\xff\xffTSource Engine Query\x00' >&3
  dd bs=4096 count=1 <&3 2>/dev/null | head -c 4 | od -An -tx1 | tr -d ' \n'
")

[ "$RESPONSE_HEX" = "ffffffff" ]
