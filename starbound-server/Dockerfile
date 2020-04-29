################################################################################
# Dockerfile that builds a Starbound Server
################################################################################

# We need the 'root' tag to install a couple of dependencies first
FROM cm2network/steamcmd:root

ENV STEAMAPPID 211820
ENV STEAMAPPDIR /home/steam/starbound-server

COPY run-prep.sh /
COPY --chown=steam util/ /home/steam/util/

RUN set -x \
	&& chmod u+x /run-prep.sh \
	&& /run-prep.sh \
	&& rm -f /run-prep.sh \
	&& su steam -c "chmod u+x ~/util/*.sh"
	
USER steam

WORKDIR $STEAMAPPDIR

# Persistant storage for the game and also the Steam folder that SteamCMD
# creates, so it doesn't need to redownload each time, and more importantly so
# it retains the login information (not 100% that's where it is).
# ---
# TODO
# Definitely want to keep the game volume but I'm considering whether or not the
# "~/Steam" volume should exist in this form, if at all.
VOLUME $STEAMAPPDIR ~/Steam

ENTRYPOINT ~/util/entrypoint.sh

EXPOSE 21025/tcp
