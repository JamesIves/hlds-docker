#!/usr/bin/env sh

GAME=${GAME:-valve}
VERSION=${VERSION:-custom}
IMAGE=${IMAGE:-custom}

if echo "$@" | grep -qv "+map"; then
  echo -e "\e[33mWarning: No +map specified in the command. Server will start but may not be joinable.\e[0m"
fi

# Push mods and config files from their temp directories to the server directories.

if [ -d /temp/mods ]
then
  rsync --recursive --update --chown=steam:steam /temp/mods/* /opt/steam/hlds
fi

if [ -d /temp/config ]
then
  rsync --recursive --update --chown=steam:steam /temp/config/* /opt/steam/hlds/$GAME
fi


echo "
                          ..::::::..              
                      :-=++++++++++++=-:          
                  :=++++=--::...::-=++++=:       
                :=+++=:              :-++++:     
                =+++-     =====:         -+++=    
              ++++.      ===+++.         .=+++   
              =+++           :+++           =+++  
            :+++.           -+++=          .+++: 
            =++=           =+++++-          =++= 
            =++-         .=++-:+++:         -+++ 
            =++=        .+++-  -+++.        =++= 
            :+++.      :+++.    =+++       .+++: 
              =+++     =++=.      ++++++=   =++=  
              =+++.  -==-        .+++=-: .=+++   
                =+++-.                   -+++=    
                :=+++=:              :=+++=:     
                  :=+++++=-::..::-=+++++=:       
                      :-=++++++++++++=-:          
                          ..::::::..              

                          hlds-docker 

====================================================================
💿 Image: $IMAGE
📎 Version: $VERSION
🎮 Game: $GAME
====================================================================

▄▄ LINKS ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█                                                                  █
█  🔧 Maintained by Jives: https://jives.dev                       █
█  💖 Support: https://github.com/sponsors/JamesIves               █
█  🔔 Feedback / Issues: https://github.com/JamesIves/hlds-docker  █
█                                                                  █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"

echo "\e[32mStarting Half-Life Dedicated Server...\e[0m"

# Start the server with the specified game and any additional arguments.
./hlds_run "-game $GAME $@"
