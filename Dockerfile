FROM ubuntu:18.04

ARG GAME

RUN if [ -z "$GAME" ]; then echo "Error: The GAME environment variable is not set, specify one and try again. Please refer to the README for instructions: https://github.com/JamesIves/hlds-docker" && exit 1; fi

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl file libc6:i386 lib32stdc++6 ca-certificates rsync && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r steam && \
    useradd -r -g steam -m -d /opt/steam steam

RUN mkdir /config

USER steam
WORKDIR /opt/steam

COPY ./hlds.txt /opt/steam

RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/steam/linux32/steamcmd && \
    ./steamcmd.sh +force_install_dir ./hlds +runscript hlds.txt +app_set_config 90 mod $GAME validate

RUN mkdir -p $HOME/.steam \
    && ln -s /opt/steam/linux32 $HOME/.steam/sdk32 \
    && echo 70 > /opt/steam/hlds/steam_appid.txt

WORKDIR /opt/steam/hlds

COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh
COPY --chown=steam:steam config $GAME

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh", "-timeout 6"]