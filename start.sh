#!/bin/bash
export MAIN_DIR=$PWD
export JAVA=$MAIN_DIR/bin/java_bins/bin/java
FILE=$HOME/.local/bin/bpytop

mem=$(grep MemTotal /proc/meminfo | sed -e 's/MemTotal:[ ]*//' | sed -e 's/ kB//') # some new stuff 
mem=$(($mem/1024/1024))



echo "> Starting the server up. Please wait..."                                                                                 
echo "> Installing Dependencise..."

sudo apt install -y -qq screen wget  

echo "> Dependencise Installed!"

# start all the screens here 
cd $MAIN_DIR/server
killall screen
screen -S server -d -m $JAVA -Xmx${mem}G -Xms${mem}G -jar start.jar nogui
screen -S afk -d -m $FILE


echo "-- Your Server is now ONLINE! --"
echo
echo "Type [screen -ls] to check the Running Processes"
echo "Type [screen -r server] to enter the Server Console"
echo "Type [screen -r afk] to enter AFK mode"