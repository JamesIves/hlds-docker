#!/usr/bin/env sh

if [ -d /tmp/$VOLUME_DIR ]
then
  rsync --chown=steam:steam /tmp/src/* /opt/steam/$GAME/valve
fi

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"

echo Starting Half-Life Dedicated Server

./hlds_linux "$@"