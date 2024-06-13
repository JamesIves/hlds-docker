#!/usr/bin/env sh

if [ -z "$GAME" ]; then 
  echo -e "\e[31mError: The GAME environment variable is not set, please refer to the README for instructions: https://github.com/JamesIves/hlds-docker\e[0m"
  exit 1
fi

if echo "$@" | grep -qv "+map"; then
  echo -e "\e[33mWarning: No +map specified in the command. Server will start but may not be joinable.\e[0m"
fi

if [ -d /temp/hlds ]
then
  rsync --chown=steam:steam /temp/hlds/* /opt/steam/hlds/$GAME
fi

echo -e "\e[32mStarting Half-Life Dedicated Server...\e[0m"

./hlds_run "-game $GAME $@"
