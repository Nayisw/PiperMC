#!/bin/bash
mkdir bin
chmod +x *
export MAIN_DIR=$PWD

# Installing Java JDK

wget -q "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz" -O bin/java.tar.xz
cd $MAIN_DIR/bin
tar -xf java.tar.xz && mv "jdk-17.0.1" java_bins



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

cd $MAIN_DIR
mkdir -p "$MAIN_DIR/server" && cd server || exit

curl -o start.jar -L "${DOWNLOAD_URL}"

echo -e "\e[33mPaperMC $VERSION downloaded successfully!\e[0m"

echo -e "\e[32mSuccessfully installed server!\e[0m"


if test -f "$HOME/.local/bin/bpytop"; then
    echo "bpytop is already installed (AFK APP RUNNING) exists."
else
	echo "bpytop is not installed. Installing AFK app. (This may take some time)."
	python3 -m pip install bpytop
fi