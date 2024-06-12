FROM ubuntu:latest

# Update base image and install dependencies.
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends curl file libc6:i386 lib32stdc++6
RUN rm -rf /var/lib/apt/lists/*

# Create steam user and group
RUN groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam

# Create game directory
RUN mkdir /gamedir

USER steam
WORKDIR /opt/steam
COPY ./hldm.install /opt/steam

# Download SteamCMD and install HLDM.
RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf -
RUN file /opt/steam/linux32/steamcmd && ./steamcmd.sh +runscript hldm.install

# Fix error that steamclient.so is missing.
RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hldm/steam_appid.txt

WORKDIR /opt/steam/hldm

# Copy configs, Metamod, Stripper2 and AMX.
COPY --chown=steam:steam gamedir valve
COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh

EXPOSE 27015
EXPOSE 27015/udp

# Start server.
ENTRYPOINT ["./entrypoint.sh", "-timeout 3"]

# Default start parameters.
CMD ["+maxplayers 12", "+map crossfire"]

# Labels
LABEL vendor=steamcalculator.com \
    hldm.docker.version="$VERSION" \
    hldm.docker.release-date="$RELEASE_DATE"