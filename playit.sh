#!/bin/bash
export MAIN_DIR=$PWD

if [ ! -d "$MAIN_DIR/server/plugins" ]; then
    echo -e "\e[31mPlease start the server once to install Playit.gg\e[0m"
else
    cd $MAIN_DIR/server/plugins || exit
    wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar
fi