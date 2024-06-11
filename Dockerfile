FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl rsync libc6:i386

# Create steam user and group
RUN groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam

USER steam
WORKDIR /opt/steam
COPY ./hldm.install /opt/steam

# Download SteamCMD and install Half-Life Dedicated Server
RUN curl -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - \
    && ldd /opt/steam/linux32/steamcmd \
    && ./steamcmd.sh +runscript hldm.install \
    && rm -fr /opt/steam/hldm/cstrike \
    && rm -fr /opt/steam/hldm/siteserverui \
    && rm -fr /opt/steam/hldm/linux64