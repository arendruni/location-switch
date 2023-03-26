#!/bin/bash

# A simple script used to switch from one network location to another, each location
# has specific parameters and is based on different interfaces.
#
# Author: dev@giun.io
# Last Update: 26th March 2023

# default network location
DEFAULT_LOCATION="Automatic"

# new location
KNOWN_LOCATIONS=(
    # add your locations here
    # m:00:11:22:33:44:55:Home 
)

# display notification when location changes
NOTIFICATION=1

# get current location
CURRENT_LOCATION=$(networksetup -getcurrentlocation)

# airport path program
AIRPORT_PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

# set new location to default location
NEW_LOCATION=$DEFAULT_LOCATION

for loc in "${KNOWN_LOCATIONS[@]}"; do
    # check if the item starts with "m" (MAC address)
    if [[ $loc == m:* ]]; then
        # extract the MAC address and location name from the item
        MAC="${loc:2:17}"
        LOCATION="${loc:20}"

        # check if the mac address matches any ethernet interface
        if (ifconfig | grep -q -E "$MAC"); then
            # set new location to the item location
            NEW_LOCATION=$LOCATION

            if [[ "$1" == "-v" ]]; then
                echo "MAC address matched \"$MAC\", new location to set: \"$NEW_LOCATION\""
            fi
            break
        fi
    # check if the item starts with "s" (SSID)
    elif [[ $loc == s:* ]]; then
        # extract the SSID and locationname from the item
        SSID="$(echo $loc | cut -d: -f2)"
        LOCATION="${loc:3+${#SSID}}"

        # check if matched ssid is currently connected
        if ($AIRPORT_PATH --getinfo | grep -q -E "$SSID$"); then
            # set new location to item location
            NEW_LOCATION=$LOCATION

            if [[ "$1" == "-v" ]]; then
                echo "SSID matched: \"$SSID\", new location to set: \"$NEW_LOCATION\""
            fi
            break
        fi
    else
        if [[ "$1" == "-v" ]]; then
            echo "Unknown location format: \"$loc\""
        fi

        exit 1
    fi
done

# switch to new location only if it changed from current location
if [ "$CURRENT_LOCATION" != "$NEW_LOCATION" ]; then
    scselect "$NEW_LOCATION"

    if [[ "$1" == "-v" ]]; then
        echo "location changed from $CURRENT_LOCATION to $NEW_LOCATION"
    fi

    # display a notification
    if [ "$NOTIFICATION" == 1 ]; then
        osascript -e "display notification \"Network location switched from $CURRENT_LOCATION to $NEW_LOCATION\" with title \"Network Location Switcher\""
    fi
else
    if [[ "$1" == "-v" ]]; then
        echo "location not changed from $CURRENT_LOCATION"
    fi
fi
