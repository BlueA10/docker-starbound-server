################################################################################
# Dockerfile that builds a Starbound Server
################################################################################

FROM cm2network/steamcmd:root

LABEL maintainer='blue_a10@posteo.net'

EXPOSE 21025/tcp

ENV STEAMAPPID 211820
ENV STEAMAPPDIR /home/steam/starbound-server

STOPSIGNAL SIGINT

COPY --chown=steam bin/ /home/steam/bin/

RUN set -x \
	&& su steam -c "mkdir -p \"${STEAMAPPDIR}\"" \
	&& su steam -c "mkdir -p /home/steam/Steam" \
	&& su steam -c "chmod u+x /home/steam/bin/*.sh"

VOLUME $STEAMAPPDIR /home/steam/Steam

RUN set -xe \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32gcc1 \
		libvorbisfile3 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

USER steam

ENTRYPOINT ["/home/steam/bin/entrypoint.sh"]
