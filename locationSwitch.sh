#!/bin/sh

# A Simple script used to switch from one network location to another, each location
# has specific parameters and is based on different interfaces.
#
# Basically it checks if an ethernet interface is connected then checks if the
# interface MAC address is a known address. Instead, checks if the WiFi SSID is a
# known SSID.
#
# Author: dev@giun.io
# Last Update: 26th March 2023

# get current location
CURRENT_LOCATION=$(networksetup -getcurrentlocation)

# default network location
DEFAULT_LOCATION=$1

# my location
MY_LOCATION=$2

# mac address regex
ETH_MAC=$3

# SSIDs regex
SSID=$4

# display notification when location changes
NOTIFICATION=$5

# check if ethernet cable is connected
if (ifconfig | grep -q -E "$ETH_MAC"); then
    # set new location
    NEW_LOCATION=$MY_LOCATION

    echo "MAC address matched $ETH_MAC"
# look for known SSIDs
elif (/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport --getinfo | grep -q -E "$SSID"); then
    # set new location
    NEW_LOCATION=$MY_LOCATION

    echo "Active SSID matched $SSID"
else
    # set new location to auto
    NEW_LOCATION=$DEFAULT_LOCATION

    echo "Nothing matched"
fi

# switch to new location only if it changed from current location
if [ "$CURRENT_LOCATION" != "$NEW_LOCATION" ]; then
    scselect "$NEW_LOCATION"

    echo "location changed from $CURRENT_LOCATION to $NEW_LOCATION"

    # display a notification
    if [ "$NOTIFICATION" == "--notification" ]; then
        osascript -e "display notification \"Network location switched from $CURRENT_LOCATION to $NEW_LOCATION\" with title \"Network Location Switcher\""
    fi
else
    echo "location not changed"
fi
