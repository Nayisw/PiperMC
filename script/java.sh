#!/bin/bash

# Check if JAVA is installed or not

java() {

    echo "Enter the Java version( 8, 11 and 17): "
    read jav_ver

    if ! command -v java &>/dev/null/; then

        if $jav_ver -eq null; then
            jav_ver=17
        fi

        if $jav_ver -eq 8; then
            sudo apt install openjdk-8-jre-headless -y

        elif $jav_ver -eq 11; then
            sudo apt install openjdk-11-jre-headless -y

        elif $jav_ver -eq 17; then
            sudo apt install openjdk-17-jre-headless -y
        fi

        echo "Java-$jav_ver installed!"
    else
        echo "You already have java installed!"
    fi
}
