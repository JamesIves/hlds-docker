#!/usr/bin/env sh

if [ -d /temp/hlds ]
then
  rsync --chown=steam:steam /temp/hlds/* /opt/steam/hlds/$GAME
fi

echo Starting Half-Life Dedicated Server...

./hlds_run "-game $GAME $@"
