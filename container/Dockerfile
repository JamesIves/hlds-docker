FROM ubuntu:24.04

# Sets an environment variable for the game to install.
# Supported games: valve, cstrike, czero, dod, dmc, gearbox, ricochet, tfc
# Default is valve. This gets replaced when building the image with --build-arg GAME=<game>
ARG GAME=valve
ENV GAME ${GAME}

# Sets an environment variable for any additional flag that should be passed to the SteamCMD installer.
# Default is an empty string. This gets replaced when building the image with --build-arg FLAG=<FLAG>
# For example, you may set this to "-beta steam_legacy".
ARG FLAG
ENV FLAG ${FLAG}

# Sets an environment variable for the version of the image.
ARG VERSION=custom
ENV VERSION ${VERSION}

# Sets an environment variable for the image name.
ARG IMAGE=custom
ENV IMAGE ${IMAGE}

# Tags the image with the Open Containers Initiative (OCI) image format.
LABEL org.opencontainers.image.title="hlds:${GAME}"
LABEL org.opencontainers.image.description="🐋 📦 Half-Life Dedicated Server powered by Docker. Supports all the classic GoldSrc Half-Life games and mods, including the ability to add custom configurations and plugins."
LABEL org.opencontainers.image.vendor="https://jamesiv.es"
LABEL org.opencontainers.image.authors="James Ives (https://jamesiv.es)"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/jamesives/hlds-docker"
LABEL org.opencontainers.image.documentation="https://github.com/jamesives/hlds-docker"
LABEL org.opencontainers.image.source="https://github.com/jamesives/hlds-docker"
LABEL org.opencontainers.image.version="${VERSION}"

# Installs the necessary dependencies for the SteamCMD installer.
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl rsync file libc6:i386 lib32stdc++6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Creates a new user and group for the SteamCMD installer.
RUN groupadd -r steam && \
    useradd -r -g steam -m -d /opt/steam steam

# Creates the necessary directories for the Half-Life Dedicated Server, including the configuration and mods directories.
RUN mkdir /config
RUN mkdir /mods
RUN mkdir /temp
RUN mkdir /temp/config
RUN mkdir /temp/mods

# Sets the user to the steam user.
USER steam
WORKDIR /opt/steam

# Copies the hlds.txt file to the container.
COPY ./hlds.txt /opt/steam

# Replaces $GAME with the requested mod to install in hlds.txt.
# Additionally replaces $FLAG with any additional flags that should be passed to the SteamCMD installer to support betas.
RUN sed -i "s/\$GAME/${GAME}/g" /opt/steam/hlds.txt
RUN sed -i "s/\$FLAG/${FLAG}/g" /opt/steam/hlds.txt

# Downloads and extracts the SteamCMD installer.
RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/steam/linux32/steamcmd && \
    ./steamcmd.sh +runscript /opt/steam/hlds.txt

# Writes the steam_appid.txt file to the hlds directory with the title id for Half-Life.
# Patches a known issue with the Steam client.
RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hlds/steam_appid.txt

WORKDIR /opt/steam/hlds

# Copies the entrypoint script to the container and sets the necessary permissions.
COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh
COPY --chown=steam:steam config $GAME
COPY --chown=steam:steam mods .

# Sets the entrypoint script as executable.
RUN chmod +x ./entrypoint.sh


ENTRYPOINT ["./entrypoint.sh"]
