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

# Start the server
start_server() {
    jar="$PWD/server/start.jar"
    BPYTOP=$HOME/.local/bin/bpytop

    screen -S afk -d -m $BPYTOP

    cd server && screen -S server -d -m java -Xms${ram} -Xmx${ram} -jar ${jar} nogui
    sleep 10
    screen -r server
}


# Funtion to install the server
install_paper() {

    echo -e "\e[32mVisit https://papermc.io/api/v2/projects/paper to see supported versions\e[0m"

    echo -e "\e[33mLeave blank and press Enter to select the latest version by default\e[0m"
    read -rp "Enter your version: " MC_VERSION

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

    mkdir -p "$PWD/server" && cd server || exit
    wget -O eula.txt https://cdn.discordapp.com/attachments/772003388455125002/1148153568877097062/eula.txt #EULA

    curl -o start.jar -L "${DOWNLOAD_URL}"

    echo -e "\e[33mPaperMC $VERSION downloaded successfully!\e[0m"

    java -jar start.jar
    echo -e "\e[32mSuccessfully installed server!\e[0m"
}

# Check if server is installed
if [ ! -d server ]; then
    echo -e "\e[33m Server not installed!\nInstall a server to continue...\e[0m"

    echo -e "\e[95m Do you want to install the server right now?\e[0m"
    echo "1. Yes"
    echo "2. No"

    read -rp "Enter your choice: " choice

    case $choice in
    1)
        install_paper
        ;;
    2)
        exit 0
        ;;
    *)
        echo "invalid choice. Closing.."
        exit 0
        ;;
    esac

fi


# Menu
main() {
    echo "==============================="
    echo "Server Menu"
    echo "-------------------------------"
    echo "1. Start Server"
    echo "2. Stop the Server"
    echo "3. Install Playit.gg"
    echo "4. Exit"

    read -rp "Enter your choice: " choice

    case $choice in
    1)
        echo "Starting the server..."
        echo "Please wait 10 seconds"
        start_server
        ;;
    2)
        echo "Closing the server..."
        killall screen
        clear
        echo -e "\e[32mType './start.sh' to start the server again!\e[0m"
        ;;
    3)
        echo "Installing Playit.gg"

        if [ ! -d "$PWD/server/plugins" ]; then
            echo -e "\e[31mPlease start the server once to install Playit.gg\e[0m"
        else
            cd server/plugins || exit
            wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar
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
