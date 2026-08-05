#!/bin/bash
source rt.sh

# Debug error/reset color
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0;0m'

# Game name
FS22="22"
FS25="25"

# Game selection
GAME_VERSION="${GAME_VERSION:-$FS25}"
if [ "$GAME_VERSION" = "$FS22" ]; then
  GAME_NAME="Farming Simulator 2022"
  GAME_NAME_SHORT="FS22"
  GAME_EXE="FarmingSimulator2022Game.exe"
else
  GAME_NAME="Farming Simulator 2025"
  GAME_NAME_SHORT="FS25"
  GAME_EXE="FarmingSimulator2025Game.exe"
fi

# Define the game installation directories on both the host and wine side
FARMSIM_INSTALL_WINE="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/Program Files (x86)/$GAME_NAME"
FARMSIM_GAME_EXE="$FARMSIM_INSTALL_WINE/x64/$GAME_EXE"
STEAM_COMPAT_INSTALL_PATH="$FARMSIM_INSTALL_WINE"
STEAM_COMPAT_LIBRARY_PATHS="$FARMSIM_INSTALL_WINE"

# Check if the game exists on Proton side
if [ -f "$FARMSIM_GAME_EXE" ]; then
  echo -e "${GREEN}INFO: Starting $GAME_NAME_SHORT server${NOCOLOR}"
  echo -e "${GREEN}INFO: Proton path: $PROTON_DIR${NOCOLOR}"
  "$PROTON_DIR/proton" runinprefix "$FARMSIM_GAME_EXE" -server
else
  echo -e "${RED}Error: Game does not exist on Proton side, unable to start the server!${NOCOLOR}"
  exit 1
fi

exit 0
