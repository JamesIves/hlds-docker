#!/usr/bin/env sh

if [ -z "$GAME" ]; then 
  echo "The GAME environment variable is not set, please refer to the README for instructions: https://github.com/JamesIves/hlds-docker"
  exit 1
fi

if [ -d /temp/hlds ]
then
  rsync --chown=steam:steam /temp/hlds/* /opt/steam/hlds/$GAME
fi

echo Starting Half-Life Dedicated Server...

./hlds_run "-game $GAME $@"
