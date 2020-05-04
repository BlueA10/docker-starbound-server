#!/bin/bash

# Entrypoint
# 1. Login to SteamCMD using $STEAM_USERNAME. Password entry required once.
# 2. Install/update game files.
# 3. CD to server executable and then launch it directly.

set -e
# Interactive prompt if env var is not set and no secret provided. Abort if
# prompt left empty.
if [[ -z "${STEAM_USERNAME}" ]] && [[ ! -s "${STEAM_USERNAME_FILE}" ]]
then
	read -p 'Please enter a Steam username to log into SteamCMD: ' \
		'STEAM_USERNAME'
	if [[ -z "${STEAM_USERNAME}" ]]
		echo 'No username entered! Aborting script.' >&2
		exit 1
	fi
fi

if [[ -z "${STEAM_PASSWORD}" ]] && [[ ! -s "${STEAM_PASSWORD_FILE}" ]]
then
	echo 'No Steam password given, SteamCMD will prompt for one.' \
		'\nIf using Docker-Compose this will cause the container' \
		'to abort with an error.'
fi
echo 'Updating game files with SteamCMD...'

# Login to SteamCMD and install the game. In this case, Starbound.
# The expansions on the login argument will expand to STEAM_USERNAME and
# STEAM_PASSWORD if set, and if not, will read in from the file path set on
# STEAM_USERNAME_FILE and STEAM_PASSWORD_FILE instead.
# If the username is blank, SteamCMD will fail. If it is not blank, but the
# password is blank, then SteamCMD will prompt for the password.
"${STEAMCMDDIR}/steamcmd.sh" \
	+login \
		"${STEAM_USERNAME:-$(<"${STEAM_USERNAME_FILE}")}" \
		"${STEAM_PASSWORD:-$(<"${STEAM_PASSWORD_FILE}")}" \
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
