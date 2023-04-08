# Network Location Switch

This bash script is designed to change the network location on a Mac based on the matching MAC address or SSID of a known network location. This can be useful if you frequently switch between different networks with different settings.

The script works by comparing the MAC address or SSID of the currently connected network to a list of known MAC addresses or SSIDs. If there is a match, the script changes the network location to the corresponding predefined location. If there is no match, the script changes the network location default location.

For more information on creating and using network locations on macOS, you can refer to the official Apple support document: [Use network locations on Mac](https://support.apple.com/en-us/HT202480).

## Compatibility

This script is intended to be used on macOS 10.15 (Catalina) or later. It may not work on older versions of macOS.

Please ensure that your system meets the minimum requirements before attempting to run this script. If you encounter any issues, please let me know and I will do my best to assist you.

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
    <string>io.giun.dev.location-switch</string>
    <key>ProgramArguments</key>
    <array>
      <string>/path/to/location-switch.sh</string>
      <string>-v</string>
    </array>
    <key>StartInterval</key>
    <integer>10</integer>
    <key>RunAtLoad</key>
    <true />
    <key>LowPriorityIO</key>
    <true />
    <key>StandardOutPath</key>
    <string>/path/to/location-switch/output.log</string>
    <key>StandardErrorPath</key>
    <string>/path/to/location-switch/error.log</string>
  </dict>
</plist>
```

Edit the example file `io.giun.dev.location-switch.template.plist` to make sure to replace `/path/to/location-switch.sh` with the actual path to your script.

To load the `launchd` configuration, run the following command:

```shell
$ launchctl load io.giun.dev.location-switch.plist
```

This will start the script and run it every 10 seconds. You can view the script output in the log file specified in the configuration file. To stop the script, unload the `launchd` configuration with the following command:

```shell
$ launchctl unload io.giun.dev.location-switch.plist
```

Move the `.plist` file to the `~/Library/LaunchAgents` to launch the agent at startup.
