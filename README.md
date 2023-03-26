# Network Location Switch

This bash script is designed to change the network location on a Mac based on the matching MAC address or SSID of a known network location. This can be useful if you frequently switch between different networks with different settings.

The script works by comparing the MAC address or SSID of the currently connected network to a list of known MAC addresses or SSIDs. If there is a match, the script changes the network location to the corresponding predefined location. If there is no match, the script changes the network location default location.

## Usage

To use this script, you will need to change the following variables at the beginning of the script:

- `DEFAULT_LOCATION` - the name of the default network location
- `KNOWN_LOCATIONS` - a list of known MAC addresses or SSIDs and their corresponding network locations

### `KNOWN_LOCATIONS` Format

The `KNOWN_LOCATIONS` array is a list of items that represent known locations in the format of MAC addresses and SSIDs. Each item in the array consists of three parts:

A prefix to indicate whether the item is a MAC address or an SSID.
The MAC address or SSID value.
A name for the location.
The prefix and value are separated by a colon (":") character. The name is separated from the value by another colon.

Note that the name for the location is required and must be provided for each item in the array.

Example:

```bash
KNOWN_LOCATIONS=(
  "m:00:11:22:33:44:55:Home"
  "s:MyWiFiSSID:Office"
)
```

#### MAC Address Format

MAC address items have the prefix "m". The value of a MAC address item is a standard MAC address string consisting of six colon-separated pairs of hexadecimal digits. The name of the location follows the MAC address value and is separated by a colon. Example: `m:00:11:22:33:44:55:Home`

#### SSID Format

SSID items have the prefix "s". The value of an SSID item is a string representing the name of a WiFi network. The name of the location follows the SSID value and is separated by a colon. Example: `s:MyWiFiSSID:Office`


## Demonizing the Script on macOS

To run this script as a background process on macOS, you can use the `launchd` system. Here's a template `launchd` configuration file you can use:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.example.network_location_changer</string>
    <key>Program</key>
    <string>/path/to/network_location_changer.sh</string>
    <key>StartInterval</key>
    <integer>10</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>LowPriorityIO</key>
    <key>StandardOutPath</key>
    <string>/path/to/network_location_changer.log</string>
    <key>StandardErrorPath</key>
    <string>/path/to/network_location_changer.log</string>
    <key>Disabled</key>
    <false/>
  </dict>
</plist>
```

Save this file as `com.example.network_location_changer.plist` in the `/Library/LaunchAgents/` directory. Make sure to replace `/path/to/network_location_changer.sh` with the actual path to your script.

To load the `launchd` configuration, run the following command:

```shell
$ launchctl load /Library/LaunchAgents/com.example.network_location_changer.plist
```

This will start the script and run it every 10 seconds. You can view the script output in the log file specified in the configuration file. To stop the script, unload the `launchd` configuration with the following command:

```shell
$ launchctl unload /Library/LaunchAgents/com.example.network_location_changer.plist
```