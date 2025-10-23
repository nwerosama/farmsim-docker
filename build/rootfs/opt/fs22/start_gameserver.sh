#!/bin/bash

export WINEDLLOVERRIDES=mscoree=d
export WINEDEBUG=-all
export WINEPREFIX=~/.fs_server
export WINEARCH=win64
export USER=nobody

# Debug error/reset color
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0;0m'

# Boot the wine prefix
wineboot

# Define the game installation directories on both the host and wine side
FARMSIM_INSTALL_WINE="$WINEPREFIX/drive_c/Program Files (x86)/Farming Simulator 2022"
FARMSIM_DOCS_HOST="/opt/fs22/docs"
FARMSIM_DOCS_WINE_PARENT="$WINEPREFIX/drive_c/users/$USER/Documents/My Games"
FARMSIM_DOCS_WINE="$FARMSIM_DOCS_WINE_PARENT/FarmingSimulator2022"
FARMSIM_GAME_APP="$FARMSIM_INSTALL_WINE/x64/FarmingSimulator2022Game.exe"

# Symlink the game profile directory
if [ -d "$FARMSIM_DOCS_WINE" ]; then
  echo -e "${GREEN}INFO: The symlink is already in place, no need to create one!${NOCOLOR}"
else
  mkdir -p "$FARMSIM_DOCS_WINE_PARENT" && ln -s "$FARMSIM_DOCS_HOST" "$FARMSIM_DOCS_WINE"
fi

# Check if the game exists on the WINE side
if [ -f "$FARMSIM_GAME_APP" ]; then
  wine "$FARMSIM_GAME_APP" -server
else
  echo -e "${RED}Error: Game does not exist on the WINE side, unable to start the server!${NOCOLOR}"
  exit 1
fi

exit 0
