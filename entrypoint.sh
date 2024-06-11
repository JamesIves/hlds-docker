#!/usr/bin/env sh

if [ -d /tmp/gamedir ]
then
  rsync --chown=steam:steam /tmp/gamedir/* /opt/steam/hldm/valve
fi

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"

echo Starting HLDS...
./hlds_linux "$@"