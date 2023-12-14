#!/bin/bash


### THIS PROJECT IS OPEN SOURCE
### FEEL FREE TO CONTRIBUTE TOWARD THIS PROJECT
### PLEASE CREDIT THE OWNER OF THE PROJECT :)
### Script made by @Nayisw

### <----- RAM CONFIGURATION

ram='1G' #   <---- CHANGE THIS VALUE TO YOUR DESIRED VALUE

### RAM CONFIGURATION ----->

###  [ !!! DO NOT CHANGE ANYTHING BELOW THIS !!! ]

# Check and install dependencies
sudo chmod +x *
dependencies() {
    if ! command -v java &>/dev/null; then
        sudo apt install default-jdk -y
    fi

    if ! command -v screen &>/dev/null; then
        sudo apt install screen -y
    fi

    if ! command -v jq &>/dev/null; then
        sudo apt install jq -y
    fi

    if ! test -f $HOME/.local/bin/bpytop; then
        echo "Bpytop is not installed!. Installing AFK app (This may take some time)"

        if ! test python; then
            sudo apt install python
        fi

        python3 -m pip install bpytop &>/dev/null
    else
        echo "Bpytop is alrdy installed!"
    fi

    sudo apt update
}
dependencies
echo -e "\e[32mDependencies Installed!\e[0m"

# Funtion to install the server
install_paper() {

    echo -e "\e[32mVisit https://papermc.io/api/v2/projects/paper to see supported versions\e[0m"

    echo -e "\e[33mLeave blank and press Enter to select the latest version by default\e[0m"
    echo -e "\e[34mEnter your version: \e[0m"
    read MC_VERSION

    API_URL="https://papermc.io/api/v2/projects/paper"

    if [ -z "$MC_VERSION" ]; then
        LATEST_VERSION=$(curl -s "${API_URL}" | jq -r '.versions' | jq -r '.[-1]')
        MC_VERSION="${LATEST_VERSION}"
        LATEST_BUILD=$(curl -s "${API_URL}/versions/${LATEST_VERSION}" | jq -r '.builds | .[-1]')
        VERSION="${LATEST_VERSION}-${LATEST_BUILD}"
        DOWNLOAD_URL="${API_URL}/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/paper-${VERSION}.jar"
    else
        VER_BUILD=$(curl -s "${API_URL}/versions/${MC_VERSION}" | jq -r '.builds | .[-1]')
        VERSION="${MC_VERSION}-${VER_BUILD}"
        DOWNLOAD_URL="${API_URL}/versions/${MC_VERSION}/builds/${VER_BUILD}/downloads/paper-${VERSION}.jar"
    fi

    mkdir -p "$PWD/server" && cd server
    wget -O eula.txt https://cdn.discordapp.com/attachments/772003388455125002/1148153568877097062/eula.txt #EULA

    curl -o start.jar -L "${DOWNLOAD_URL}"

    echo -e "\e[33mPaperMC $VERSION downloaded successfully!\e[0m"
}
echo -e "\e[32mSuccessfully installed server!\e[0m"

# Check if server is installed
if [ ! -d server ]; then
    echo -e "\e[33m Server not installed!\nInstall a server to continue...\e[0m"

    echo -e "\95m Do you want to install the server right now?\e[0m"
    echo "1. Yes"
    echo "2. No"
    read yn
    if $yn -eq 1; then
        install_paper
    elif $yn -eq 2; then
        exit 0
    fi

fi

# Start the server
start_server() {
    cd server 
    jar="start.jar"
    BPYTOP=$HOME/.local/bin/bpytop

    screen -S afk -d -m $BPYTOP

    screen -S server -d -m java -Xms${ram} -Xmx${ram} -jar ${jar} nogui
    screen -r server

}

# Menu
main() {
    echo "==============================="
    echo "Server Menu"
    echo "-------------------------------"
    echo "1. Start Server"
    echo "2. Install Playit.gg"
    echo "3. Exit"

    read -rp "Enter your choice: " choice

    case $choice in
    1)
        echo "Starting the server..."
        start_server
        ;;
    2)
        echo "Closing the server..."
        killall screen
        clear
        echo -e "\e32mType './start.sh' to start the server again!"
        ;;
    3)
        echo "Installing Playit.gg"

        if [ -d server/plugins ]; then
            cd server/plugins
            wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar
        else
            echo "Please start the server once to install Playit.gg"
        fi

        ;;

    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please choose a valid option."
        ;;
    esac

}
main
