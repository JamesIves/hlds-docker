#!/usr/bin/env sh

# Set GAME to its value if defined, or 'valve' if not
GAME=${GAME:-valve}

if echo "$@" | grep -qv "+map"; then
  echo -e "\e[33mWarning: No +map specified in the command. Server will start but may not be joinable.\e[0m"
fi

if [ -d /temp/mods ]
then
  rsync --chown=steam:steam /temp/mods/* /opt/steam/hlds
fi

if [ -d /temp/config ]
then
  rsync --chown=steam:steam /temp/config/* /opt/steam/hlds/$GAME
fi

echo -e "\e[32mStarting Half-Life Dedicated Server for $GAME...\e[0m"

./hlds_run "-game $GAME $@"
