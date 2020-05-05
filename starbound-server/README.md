# starbound-server

My attempt at making a Starbound dedicated server Docker image, for my own server uses and for the learning experience and fun of it.

Currently in the phase where I'm learning a lot of new things at once and changing things frequently as I carve out a better idea of what I want with this and how I'm going to do it.

Pull and run at your own peril.

```bash
docker run -ti -p 21025:21025 bluea10/starbound-server:latest
```

You can detach after succesfully logging in to SteamCMD.

Alternatively, you may pass STEAM_USERNAME and STEAM_PASSWORD environment variables to have them entered into SteamCMD for you. However, I recommend against doing so or at least passing them in via env files instead. This will not keep the info secret as I believe it will still be visible in a Docker history log or ps somewhere, but will at least keep it off your command line. Steam Guard will also still require manual entry of the 2FA code directly into SteamCMD if enabled.

To pass environment variables directly, modify the above command with the -e option like so:

```bash
docker run -ti -p 21025:21025 -e STEAM_USERNAME='username' -e STEAM_PASSWORD='password' bluea10/starbound-server:latest
```

To do so via env file instead, use the --env-file option like so:

```bash
docker run -ti -p 21025:21025 --env-file "steam-credentials.env" bluea10/starbound-server:latest
```

Where 'steam-credentials.env' is an arbitrarily-named text file containing:

```bash
# Comments are allowed
STEAM_USERNAME='username'
STEAM_PASSWORD='password'
```

The recommended method for handling credentials will be through the docker-compose setup once complete. Current vision of this is keeping credentials in steam_username.txt and steam_password.txt files or in a single credentials file like the env file example above, which will be passed to the container encrypted via Docker Secrets using configurations in the docker-compose file.

I will be researching to see if there is an easy and secure alternative to keeping them in plain-text text files on the host machine, as that is still a concern I have, but as long as it can be passed to the container via Docker Secrets and docker-compose regardless of how it's stored on the host machine, I am comfortable with the Docker side of things.

## Docker Compose

### 2020-05-03

The docker-compose file offers handy benefits, such as being able to auto-login to SteamCMD without manually entering the Steam username/password via text files and Docker secrets. It will eventually also launch a Docker instance of starrypy3k alongside the starbound-server container.

Will add details on usage.

### 2020-05-04

WARNING: When using the supplied docker-compose file, there is currently not a way to manually enter login information to SteamCMD directly. These prompts either stop the container themselves or what I'm guessing is they just automatically throw errors and cause everything to abort, then the container will go into a restart loop until stopped or brought down. Currently, on the host machine shell this appears as 'docker-compose up' ending without any output from starbound-server.
I'll be researching on if the restart loop can be avoided.

To use the docker-compose file, clone the repo and then create the following two files:

```bash
./starbound-server/steam_username.txt
./starbound-server/steam_password.txt
```

Enter the steam account credentials to log in to SteamCMD with into these files to have them passed to the container's SteamCMD via Docker Secrets.

The docker-compose file currently will not work with Steam Guard enabled in either capacity.

Afterwards, cd to the repo's base directory and do:

```bash
docker-compose up
```
To shut down the server, cd to the repo again and do:

```bash
docker-compose down
```
