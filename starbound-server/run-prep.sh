#!/bin/bash
set -xe
apt-get update
apt-get install -y --no-install-recommends --no-install-suggests \
	lib32gcc1 \
	libvorbisfile3
apt-get clean autoclean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
# Create the directories that will be used as volumes under Steam user
su steam -c "mkdir -p ${STEAMAPPDIR}"
su steam -c "mkdir -p ~/Steam"
