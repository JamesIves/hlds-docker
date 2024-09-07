#!/usr/bin/env sh

GAME=${GAME:-valve}
VERSION=${VERSION:-custom}

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


IRed='\033[0;91m'         # Red
IYellow='\033[0;93m'      # Yellow
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
Color_Off='\033[0m' 

echo -e "\033[0;91m
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
\033[0;97m
                          hlds-docker 
${IYellow}
▄▄ ${IWhite}LINKS${IYellow} ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█                                                                  █
█  ${IWhite}🔧 Maintained by Jives: https://jives.dev${IYellow}                       █
█  ${IWhite}💖 Support: https://github.com/sponsors/JamesIves${IYellow}               █
█  ${IWhite}🔔 Feedback / Issues: https://github.com/JamesIves/hlds-docker${IYellow}  █
█                                                                  █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
${IPurple}
▄▄ ${IWhite}STARTUP${IPurple} ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█                                                                  █
█  ${IWhite}🔧 Container Version: ${VERSION} ${IPurple}                                   █
█                                                                  █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
\033[0m
"

# Start the server with the specified game and any additional arguments.
./hlds_run "-game $GAME $@"
