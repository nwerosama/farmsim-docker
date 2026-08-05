#!/bin/bash
source rt.sh

# Debug error/reset color
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NOCOLOR='\033[0;0m'

# Game name
FS22="22"
FS25="25"

# Game selection
GAME_VERSION="${GAME_VERSION:-$FS25}"
if [ "$GAME_VERSION" = "$FS22" ]; then
  GAME_NAME="Farming Simulator 2022"
  DOCS_DIR="FarmingSimulator2022"
  XML_STORE="fs22"
else
  GAME_NAME="Farming Simulator 2025"
  DOCS_DIR="FarmingSimulator2025"
  XML_STORE="fs25"
fi

# Define the game installation directories on both the host and wine side
FARMSIM_INSTALL_WINE="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/Program Files (x86)/$GAME_NAME"
FARMSIM_DOCS_HOST="/opt/fs${GAME_VERSION}/docs"
FARMSIM_DOCS_WINE_PARENT="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/users/steamuser/Documents/My Games"
FARMSIM_DOCS_WINE="$FARMSIM_DOCS_WINE_PARENT/$DOCS_DIR"
FARMSIM_DOCS_DEDI_CONF="$FARMSIM_DOCS_WINE/dedicated_server/dedicatedServerConfig.xml"
FARMSIM_DEDI_CONF="$FARMSIM_INSTALL_WINE/dedicatedServer.xml"
FARMSIM_DEDI_SOFTWARE="$FARMSIM_INSTALL_WINE/dedicatedServer.exe"
FARMSIM_DEDI_XML="/home/$USER/xml/$XML_STORE"

# Symlink the game profile directory
if [ -d "$FARMSIM_DOCS_WINE" ]; then
  echo -e "${GREEN}INFO: The symlink is already in place, no need to create one!${NOCOLOR}"
else
  echo -e "${BLUE}DEBUG: Executing mkdir and ln as $(whoami)${NOCOLOR}"
  mkdir -p "$FARMSIM_DOCS_WINE_PARENT" && ln -s "$FARMSIM_DOCS_HOST" "$FARMSIM_DOCS_WINE"
fi

# Copy webserver config
if [ ! -f "$FARMSIM_DEDI_CONF" ]; then
  echo -e "${GREEN}INFO: Copying the webserver config!${NOCOLOR}"
  cp "$FARMSIM_DEDI_XML/default_dedicatedServer.xml" "$FARMSIM_DEDI_CONF"
else
  echo -e "${GREEN}INFO: Webserver config already exists! Skipping..${NOCOLOR}"
fi

# Copy server config
if [ ! -f "$FARMSIM_DOCS_DEDI_CONF" ]; then
  echo -e "${GREEN}INFO: Copying the server config!${NOCOLOR}"
  cp "$FARMSIM_DEDI_XML/default_dedicatedServerConfig.xml" "$FARMSIM_DOCS_DEDI_CONF"
else
  echo -e "${GREEN}INFO: Server config already exists! Skipping..${NOCOLOR}"
fi

# Check if the server software exists on Proton side
if [ -f "$FARMSIM_DEDI_SOFTWARE" ]; then
  echo -e "${BLUE}DEBUG: Webinterface should be online in few seconds!${NOCOLOR}"
  echo -e "${BLUE}DEBUG: If it's not reachable, verify that host's port is listening to the port defined in $FARMSIM_DEDI_CONF${NOCOLOR}"
  "$PROTON_DIR/proton" run "$FARMSIM_DEDI_SOFTWARE"
else
  echo -e "${RED}Error: Dediserver software does not exist on Proton side, unable to start the server!${NOCOLOR}"
  exit 1
fi

exit 0
