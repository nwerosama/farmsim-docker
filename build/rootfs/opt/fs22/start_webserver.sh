#!/bin/bash

export WINEDLLOVERRIDES=mscoree=d
export WINEDEBUG=-all
export WINEPREFIX=~/.fs_server
export WINEARCH=win64
export USER=nobody

# Debug error/reset color
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NOCOLOR='\033[0;0m'

# Boot the wine prefix
wineboot

# Define the game installation directories on both the host and wine side
FARMSIM_INSTALL_WINE="$WINEPREFIX/drive_c/Program Files (x86)/Farming Simulator 2022"
FARMSIM_DOCS_HOST="/opt/fs22/docs"
FARMSIM_DOCS_WINE_PARENT="$WINEPREFIX/drive_c/users/$USER/Documents/My Games"
FARMSIM_DOCS_WINE="$FARMSIM_DOCS_WINE_PARENT/FarmingSimulator2022"
FARMSIM_DOCS_DEDI_CONF="$FARMSIM_DOCS_WINE/dedicated_server/dedicatedServerConfig.xml"
FARMSIM_DEDI_SOFTWARE="$FARMSIM_INSTALL_WINE/dedicatedServer.exe"
FARMSIM_DEDI_XML="/opt/fs22/xml"

# Symlink the game profile directory
if [ -d "$FARMSIM_DOCS_WINE" ]; then
  echo -e "${GREEN}INFO: The symlink is already in place, no need to create one!${NOCOLOR}"
else
  mkdir -p "$FARMSIM_DOCS_WINE_PARENT" && ln -s "$FARMSIM_DOCS_HOST" "$FARMSIM_DOCS_WINE"
fi

# Copy dedicatedServer executable
if [ ! -f "$LOCAL_DEDI_SOFTWARE" ]; then
  cp "$FARMSIM_DEDI_SOFTWARE" "$LOCAL_DEDI_SOFTWARE"
fi

# Copy the web_data directory
if [ ! -d "$LOCAL_DEDI_SOFTWARE_DIR/web_data" ]; then
  echo -e "${GREEN}INFO: Copying the web_data from game files to profile's dedicated_server directory${NOCOLOR}"
  mkdir -p "$LOCAL_DEDI_SOFTWARE_DIR"
  cp -R "$FARMSIM_INSTALL_WINE/web_data" "$LOCAL_DEDI_SOFTWARE_DIR"
fi

# Copy webserver config
if [ ! -f "$LOCAL_DEDI_SOFTWARE_CONF" ]; then
  echo -e "${GREEN}INFO: Copying the webserver config!${NOCOLOR}"
  cp "$FARMSIM_DEDI_XML/default_dedicatedServer.xml" "$LOCAL_DEDI_SOFTWARE_CONF"
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

# Check if the server software exists on the WINE side
if [ -f "$LOCAL_DEDI_SOFTWARE" ]; then
  echo -e "${BLUE}DEBUG: Webinterface port currently listens to ${WEB_PORT}${NOCOLOR}"
  wine "$LOCAL_DEDI_SOFTWARE"
else
  echo -e "${RED}Error: Dediserver software does not exist on the WINE side, unable to start the server!${NOCOLOR}"
  exit 1
fi

exit 0
