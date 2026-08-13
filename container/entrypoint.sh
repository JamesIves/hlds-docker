#!/usr/bin/env sh

GAME=${GAME:-valve}
VERSION=${VERSION:-custom}
IMAGE=${IMAGE:-custom}

if echo "$@" | grep -qv "+map"; then
  echo -e "\e[33mWarning: No +map specified in the command. Server will start but may not be joinable.\e[0m"
fi

# Every example in the docs/compose files uses "changeme" as a placeholder -
# warn if it looks like it was never actually changed, since RCON grants
# full remote admin control over the server.
if echo "$@" | grep -Eqi '\+rcon_password[[:space:]]+"?changeme"?([[:space:]]|$)'; then
  echo -e "\e[33mWarning: rcon_password is still set to the example default 'changeme'. Anyone can use RCON to administer your server - change it to something private.\e[0m"
fi

# Opt-in: re-run SteamCMD against the persisted install dir before launch so
# a container restart can pick up Valve patches without an image rebuild.
# Runs before the mods/config sync below so user-provided files still win if
# an update restores a default (e.g. motd.txt, mapcycle.txt).
if [ "$AUTO_UPDATE" = "1" ] || [ "$AUTO_UPDATE" = "true" ]; then
  echo "AUTO_UPDATE is enabled, checking Steam for updated $GAME game files..."
  /opt/steam/steamcmd.sh \
    +@ShutdownOnFailedCommand 0 \
    +@NoPromptForPassword 1 \
    +force_install_dir /opt/steam/hlds \
    +login anonymous \
    +app_set_config 90 mod "$GAME" \
    +app_update 90 $FLAG validate \
    +quit
fi

# Push mods and config files from their temp directories to the server directories.

if [ -d /temp/mods ]
then
  rsync --recursive --chown=steam:steam /temp/mods/* /opt/steam/hlds
fi

if [ -d /temp/config ]
then
  rsync --recursive --chown=steam:steam /temp/config/* /opt/steam/hlds/$GAME
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
# sv_tags is before $@ so a user-supplied +sv_tags overrides it (last wins).
# exec avoids wrapping hlds_run in an extra shell layer.
exec ./hlds_run "-game $GAME +sv_tags hlds-docker $@"
