#!/usr/bin/env sh

# Set GAME to its value if defined, or 'valve' if not
GAME=${GAME:-valve}

if echo "$@" | grep -qv "+map"; then
  echo -e "\e[33mWarning: No +map specified in the command. Server will start but may not be joinable.\e[0m"
fi

# Push mods and config files from their temp directories to the server directories.
if [ -d /temp/mods ]
then
  rsync --chown=steam:steam /temp/mods/* /opt/steam/hlds
fi

if [ -d /temp/config ]
then
  rsync --chown=steam:steam /temp/config/* /opt/steam/hlds/$GAME
fi

echo -e "\e[32mStarting Half-Life Dedicated Server for $GAME...\e[0m"

# Start the server with the specified game and any additional arguments.
./hlds_run "-game $GAME $@"
