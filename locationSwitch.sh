#!/bin/sh

# Simple script to switch from one location to another, 
# each location has different network parameters and 
# interfaces. 
# It checks wheter an ethernet cable is connected or 
# the wifi interface is connected to a knwon SSID.
#
# Author: arendruni
# Last Update: 1st November 2018

# Get current location
CURRENT_LOCATION=$(networksetup -getcurrentlocation)

# Ethernet only Home location
LOCATION_ETHERNET=$1

# Mac address of home ethernet interface
ETH_MAC=$2

# Home wifi location
LOCATION_HOME=$3

# Home SSID
SSID=$4

# Auto location 
LOCATION_AUTO=$5

# Ethernet only location
LOCATION_AUTO_ETHERNET=$6

# Ethernet interface
ETH_INT=$7

# check if ethernet cable is connected
if ( ifconfig | grep -q $ETH_INT ); then
	# check if the ethernet mac is kwown (at home)
	if (ifconfig | grep -q $ETH_MAC); then
		# set new location to ethernet home
		NEW_LOCATION=$LOCATION_ETHERNET
	else
		# instead, set ne location to generic ethernet
		NEW_LOCATION=$LOCATION_AUTO_ETHERNET
	fi
# look for known SSID 
elif ( airport --getinfo | grep -q $SSID ); then
	# set new location to home
	NEW_LOCATION=$LOCATION_HOME
else
	# set new location to auto
	NEW_LOCATION=$LOCATION_AUTO
fi

# switch to new location only if it's changed from current location
if [ $CURRENT_LOCATION != $NEW_LOCATION ]; then
	scselect "$NEW_LOCATION"

	# display a notification
	osascript -e "display notification \"Network location switched from $CURRENT_LOCATION to $NEW_LOCATION\" with title \"Network Location Switcher\""
fi 
