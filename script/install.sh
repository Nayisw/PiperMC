#!/bin/bash

# Install paper server
install_paper() {
    echo -e "\e[32mVisit https://papermc.io/api/v2/projects/paper to see supported versions\e[0m"

    echo -e "\e[31mLeave blank and press Enter to select the latest version by default"
    echo "Enter your version: "
    read MC_VERSIOn

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

    mkdir -p "$PWD/server" && cd "$PWD/server"
    curl -o start.jar -L "${DOWNLOAD_URL}"
    wget -O eula.txt https://cdn.discordapp.com/attachments/772003388455125002/1148153568877097062/eula.txt

    echo -e "\e[33mPaperMC $VERSION downloaded successfully!"
}

