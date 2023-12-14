#!/bin/bash
chmod +x script

### THIS PROJECT IS OPEN SOURCE
### FEEL FREE TO CONTRIBUTE TOWARD THIS PROJECT
### PLEASE CREDIT THE OWNER OF THE PROJECT :)
### Script made by @Nayisw



### <----- RAM CONFIGURATION

ram='1G' #   <---- CHANGE THIS VALUE TO YOUR DESIRED VALUE

### RAM CONFIGURATION ----->



###  [ !!! DO NOT CHANGE ANYTHING BELOW THIS !!! ]










# Check and install dependencies
dependencies() {
    if ! command -v java &>/dev/null; then
        sudo apt install opendjdk-17-jre-headless -y
    fi

    if ! command -v Screen &>/dev/null; then
        sudo apt install Screen -y
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

# Check if server is installed

if [ ! -d $PWD/server ]; then
    echo -e "\e[33m Server not installed!\nInstall a server to continue\e[0m"

    . script/install.sh
    install_paper
fi

# Start the server
start_server() {
    jar="$PWD/server/start.jar"

    screen -S afk -d -m bpytop

    screen -S server -d -m java -Xms${ram} -Xmx${ram} -jar ${jar} nogui
    screen -r server

}

# Menu
main() {
    echo "=== Main Menu ==="
    echo "1. Start Server"
    echo "2. Other Options" # You can add more options here
    echo "3. Exit"

    read -rp "Enter your choice: " choice

    case $choice in
    1)
        echo "Starting the server..."
        start_server
        ;;
    2)
        echo "Performing other options..."

        echo "1.Java config"
        read config

        if $config -eq 1; then
            . script/java.sh
            java
        fi

        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please choose a valid option."
        ;;
    esac

}
