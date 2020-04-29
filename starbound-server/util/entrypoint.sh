#!/bin/bash

# 1. Login to SteamCMD using $STEAMUSERNAME. Password entry required once.
# 2. Install/update game files.
# 3. CD to server executable and then launch it directly.

set -e
if [ -z "$STEAMUSERNAME" ]
then
	read -p 'Please enter a Steam username to log into SteamCMD: ' \
		"STEAMUSERNAME"
else
	echo 'SteamCMD username:' "$STEAMUSERNAME"
fi

echo 'Updating game files with SteamCMD...'
"${STEAMCMDDIR}/steamcmd.sh" \
	+login "${STEAMUSERNAME}" \
	+force_install_dir "${STEAMAPPDIR}" \
	+app_update "${STEAMAPPID}" \
	+quit
echo 'Update complete.'

echo 'Launching Starbound Server...'
cd "${STEAMAPPDIR}/linux"
./starbound_server

# TODO: Figure out a way to get workshop items added to this.
# It's looking like a Docker-Compose file may handle that much better.
#
# The basic idea I have right now is to pass a list of workshop IDs, which will
# then be parsed into '+download_workshop_item <ID>' arguments for each to add
# to the steamcmd.sh call. Additional debate: arguments vs steamcmd script.
