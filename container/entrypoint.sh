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
  rsync --recursive --chown=steam:steam /temp/mods/* /opt/steam/hlds
fi

if [ -d /temp/config ]
then
  rsync --recursive --chown=steam:steam /temp/config/* /opt/steam/hlds/$GAME
fi


# ANSI color codes
O="\e[38;5;208m"  # Orange (Half-Life brand)
W="\e[97m"        # Bright white
D="\e[38;5;242m"  # Dim grey
G="\e[38;5;34m"   # Green
Y="\e[33m"        # Yellow
C="\e[36m"        # Cyan
R="\e[0m"         # Reset

echo ""
echo ""
echo -e "${D}            ██████████████████████████████████████${R}"
echo -e "${D}        ████${O}██████████████████████████████████${D}████${R}"
echo -e "${D}      ██${O}██████████████████████████████████████████${D}██${R}"
echo -e "${D}    ██${O}██████████████████████████████████████████████${D}██${R}"
echo -e "${D}   █${O}██████████${W}██${O}██████████████████████████████████${D}█${R}"
echo -e "${D}  █${O}█████████${W}████${O}█████████████████████████████████████${D}█${R}"
echo -e "${D}  █${O}████████${W}██${O}██${W}██${O}████████████████████████████████████${D}█${R}"
echo -e "${D} █${O}████████${W}██${O}████${W}██${O}██████████████████████████████████${D}██${R}"
echo -e "${D} █${O}███████${W}██${O}██████${W}██${O}████████████████████████████████${D}███${R}"
echo -e "${D} █${O}██████${W}██${O}████████${W}████${O}██████████████████████████${D}█████${R}"
echo -e "${D} █${O}█████${W}██${O}██████████${W}██████${O}██████████████████████${D}███████${R}"
echo -e "${D} █${O}████${W}██${O}████████████${W}████████${O}████████████████${D}██████████${R}"
echo -e "${D}  █${O}██${W}████${O}██████████████${W}██████████${O}██████████${D}███████████${R}"
echo -e "${D}  █${O}█${W}██████${O}████████████████${W}████████${O}████████${D}████████████${R}"
echo -e "${D}   █${O}████████${O}██████████████████${W}██████${O}██████${D}██████████████${R}"
echo -e "${D}    ██${O}██████████████████████████████${W}████${O}████${D}██████████████${R}"
echo -e "${D}      ██${O}██████████████████████████████${W}██${O}██${D}████████████████${R}"
echo -e "${D}        ████${O}██████████████████████████████${D}██████████████████${R}"
echo -e "${D}            ██████████████████████████████████████${R}"
echo ""
echo -e "${W}                    h l d s - d o c k e r${R}"
echo ""
echo -e "${O}════════════════════════════════════════════════════════════════${R}"
echo -e "${W}  💿  Image:    ${C}$IMAGE${R}"
echo -e "${W}  📎  Version:  ${C}$VERSION${R}"
echo -e "${W}  🎮  Game:     ${C}$GAME${R}"
echo -e "${O}════════════════════════════════════════════════════════════════${R}"
echo ""
echo -e "${O}  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${R}"
echo -e "${O}  █                                                          █${R}"
echo -e "${O}  █${R}  ${G}🔧${R}  Maintained by Jives   ${D}https://jives.dev${R}               ${O}█${R}"
echo -e "${O}  █${R}  ${Y}💖${R}  Support               ${D}https://github.com/sponsors/JamesIves${R}  ${O}█${R}"
echo -e "${O}  █${R}  ${C}🔔${R}  Feedback / Issues     ${D}https://github.com/JamesIves/hlds-docker${R}  ${O}█${R}"
echo -e "${O}  █                                                          █${R}"
echo -e "${O}  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${R}"
echo ""

echo "\e[32mStarting Half-Life Dedicated Server...\e[0m"

# Start the server with the specified game and any additional arguments.
./hlds_run "-game $GAME $@"
