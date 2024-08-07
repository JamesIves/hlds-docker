FROM ubuntu:18.04

LABEL org.opencontainers.image.title="hlds"
LABEL org.opencontainers.image.description="🐋 📦 Half-Life Dedicated Server powered by Docker. Supports all the classic GoldSrc Half-Life games and mods, including the ability to add custom configurations and plugins."
LABEL org.opencontainers.image.vendor="https://jamesiv.es"
LABEL org.opencontainers.image.authors="James Ives"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/jamesives/hlds-docker"
LABEL org.opencontainers.image.documentation="https://github.com/jamesives/hlds-docker"
LABEL org.opencontainers.image.source="https://github.com/jamesives/hlds-docker"

# Sets an environment variable for the game to install.
# Supported games: valve, cstrike, czero, dod, dmc, gearbox, ricochet, tfc
# Default is valve. This get replaced when building the image with --build-arg GAME=<game>
ARG GAME=valve
ENV GAME ${GAME}

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl rsync file libc6:i386 lib32stdc++6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r steam && \
    useradd -r -g steam -m -d /opt/steam steam

RUN mkdir /config
RUN mkdir /mods

USER steam
WORKDIR /opt/steam

COPY ./hlds.txt /opt/steam

# Replaces $GAME with the requested mod to install in hlds.txt.
RUN sed -i "s/\$GAME/${GAME}/g" /opt/steam/hlds.txt

RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/steam/linux32/steamcmd && \
    ./steamcmd.sh +runscript /opt/steam/hlds.txt

# Writes the steam_appid.txt file to the hlds directory with the title id for Half-Life.
# Patches a known issue with the Steam client.
RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hlds/steam_appid.txt

WORKDIR /opt/steam/hlds

COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh
COPY --chown=steam:steam config $GAME
COPY --chown=steam:steam mods .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]