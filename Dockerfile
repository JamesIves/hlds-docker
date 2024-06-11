FROM debian:bullseye-slim

ENV VERSION 2021.9
ENV RELEASE_DATE 2021-09-05
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Update base image and install dependencies.
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    rsync \
    libc6:i386 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam \
    && mkdir /gamedir

USER steam
WORKDIR /opt/steam
COPY ./hldm.install /opt/steam

# Download SteamCMD and install HLDM.
RUN curl -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - \
    && ldd /opt/steam/linux32/steamcmd \
    && ./steamcmd.sh +runscript hldm.install \
    && rm -fr /opt/steam/hldm/cstrike \
    && rm -fr /opt/steam/hldm/siteserverui \
    && rm -fr /opt/steam/hldm/linux64