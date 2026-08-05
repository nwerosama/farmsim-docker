#!/bin/bash

# Wine stuff
# export WINEDLLOVERRIDES=mscoree=d
export WINEDEBUG=-all
export WINEARCH=win64

# Proton stuff
export PROTONFIXES_DISABLE=1
export PROTON_USE_WINED3D=0
export PROTON_DIR=/opt/proton/current
export STEAM_COMPAT_DATA_PATH=/home/nobody/.fs_server
export STEAM_COMPAT_CLIENT_INSTALL_PATH=/home/nobody/.steam
