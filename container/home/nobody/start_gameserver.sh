#!/bin/bash

export WINEDLLOVERRIDES=mscoree=d
export WINEDEBUG=-all
export WINEPREFIX=~/.fs_server
export WINEARCH=win64
export USER=nobody

# Debug error/reset color
RED='\033[0;31m'
NOCOLOR='\033[0;0m'

# Boot the wine prefix
wineboot

# Game name
FS22="22"
FS25="25"

# Game selection
GAME_VERSION="${GAME_VERSION:-$FS25}"
if [ "$GAME_VERSION" = "$FS22" ]; then
  GAME_NAME="Farming Simulator 22"
  GAME_EXE="FarmingSimulator2022Game.exe"
else
  GAME_NAME="Farming Simulator 2025"
  GAME_EXE="FarmingSimulator2025Game.exe"
fi

# Define the game installation directories on both the host and wine side
FARMSIM_INSTALL_WINE="$WINEPREFIX/drive_c/Program Files (x86)/$GAME_NAME"
FARMSIM_GAME_EXE="$FARMSIM_INSTALL_WINE/x64/$GAME_EXE"

# Check if the game exists on the WINE side
if [ -f "$FARMSIM_GAME_EXE" ]; then
  wine "$FARMSIM_GAME_EXE" -server
else
  echo -e "${RED}Error: Game does not exist on the WINE side, unable to start the server!${NOCOLOR}"
  exit 1
fi

exit 0
