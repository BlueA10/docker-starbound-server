################################################################################
# Dockerfile that builds a Starbound Server
################################################################################

# We need the 'root' tag to install a couple of dependencies first
FROM cm2network/steamcmd:root

# Starbound App ID = 211820
ENV STEAMAPPID 211820
ENV STEAMAPPDIR /home/steam/starbound-server

COPY run-prep.sh /

RUN set -x \
	/run-prep.sh \
	&& rm -f /run-prep.sh
	
USER steam

WORKDIR $STEAMAPPDIR

# Persistant storage for the game and also the Steam folder that SteamCMD
# creates, so it doesn't need to redownload each time, and more importantly so
# it retains the login information (not 100% that's where it is).
VOLUME $STEAMAPPDIR ~/Steam

# Set Entrypoint
# 1. Login to SteamCMD using $STEAMUSERNAME. Password entry required only once.
# 2. Install/update game files.
# 3. CD to server executable and then launch it directly.

# It's not at the same level, but to quote the comments on cm2network/mordhau:
# "You may not like it, but this is what peak Entrypoint looks like."
ENTRYPOINT echo 'Updating game files.' \
	&& if [ -z "$STEAMUSERNAME" ]; \
	then \
		read -p 'Please enter a Steam username to log into SteamCMD: '\
		"STEAMUSERNAME"; \
	else \
		echo 'SteamCMD username:' "$STEAMUSERNAME"; \
	fi \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+login "${STEAMUSERNAME}" \
		+force_install_dir "${STEAMAPPDIR}" \
		+app_update "${STEAMAPPID}" \
		+quit \
	&& cd "${STEAMAPPDIR}/linux" && ./starbound_server
# <TODO: Figure out a way to get workshop items added to this, maybe via
# Maximum Entrypoint? Still learning things and that seems inelegant, so
# hopefully a better option appears.>

# Starbound uses 21025/tcp by default. Expose here and leave Starbound default,
# remapping/forwarding to different ports as needed.
EXPOSE 21025/tcp
