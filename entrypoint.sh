#!/usr/bin/env sh

# Script variables
GAME_DIR="$(pwd)"
GAME_BIN="SonsOfTheForestDS.exe"
GAME_USERDATA="$GAME_DIR/userdata"
GAME_ARGS="-batchmode -dedicated -nographics -userdatapath $GAME_USERDATA"

# Check if required files exist
if [ ! -f "$GAME_BIN" ]; then
    echo "Error: Game binary not found: $GAME_BIN"
    exit 1
fi

# Start the game server
xvfb-run --auto-servernum --server-args="-screen 0 640x480x24:32" wine $GAME_BIN $GAME_ARGS
