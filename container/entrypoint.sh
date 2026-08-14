#!/usr/bin/env sh

GAME=${GAME:-valve}
VERSION=${VERSION:-custom}
IMAGE=${IMAGE:-custom}

if echo "$@" | grep -qv "+map"; then
  printf '\033[33mWarning: No +map specified in the command. Server will start but may not be joinable.\033[0m\n'
fi

# Every doc/compose example uses "changeme" - warn if it was never changed.
# Also drops a sentinel file: CI checks that instead of docker logs, which can lag under load.
if echo "$@" | grep -Eqi '\+rcon_password[[:space:]]+"?changeme"?([[:space:]]|$)'; then
  printf '\033[33mWarning: rcon_password is still set to the example default '"'"'changeme'"'"'. Anyone can use RCON to administer your server - change it to something private.\033[0m\n'
  touch /tmp/.rcon-default-password-warning-shown
fi

# Lets rcon_password come from a mounted secret instead of the plaintext command line.
RCON_ARGS=""
if [ -n "$RCON_PASSWORD_FILE" ]; then
  if [ -f "$RCON_PASSWORD_FILE" ]; then
    RCON_ARGS="+rcon_password $(cat "$RCON_PASSWORD_FILE")"
  else
    printf '\033[33mWarning: RCON_PASSWORD_FILE is set to '"'"'%s'"'"' but that file does not exist.\033[0m\n' "$RCON_PASSWORD_FILE"
  fi
fi

# Opt-in game file refresh - runs before the mods/config sync so user files still win.
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
  touch /tmp/.auto-update-ran
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

printf '\033[32mStarting Half-Life Dedicated Server...\033[0m\n'

# Start the server with the specified game and any additional arguments.
# sv_tags/RCON_ARGS are before $@ so a user-supplied +sv_tags/+rcon_password overrides them (last wins).
# exec avoids wrapping hlds_run in an extra shell layer.
exec ./hlds_run "-game $GAME +sv_tags hlds-docker $RCON_ARGS $@"
