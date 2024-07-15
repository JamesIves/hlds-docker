FROM ubuntu:18.04

# Sets an environment variable for the game to install.
# Supported games: valve, cstrike, czero, dod, dmc, gearbox, ricochet, tfc
# Default is valve. This get replaced when building the image with --build-arg GAME=<game>
ARG GAME=valve
ENV GAME ${GAME}

LABEL vendor="jives.dev" \
    maintainer="James Ives"

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

# Replace $GAME with the requested mod to install in hlds.txt.
RUN sed -i "s/\$GAME/${GAME}/g" /opt/steam/hlds.txt

RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/steam/linux32/steamcmd && \
    ./steamcmd.sh +runscript /opt/steam/hlds.txt

# Writes the steam_appid.txt file to the hlds directory with the title id for Half-Life.
RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hlds/steam_appid.txt

WORKDIR /opt/steam/hlds

COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh
COPY --chown=steam:steam config $GAME
COPY --chown=steam:steam mods .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]