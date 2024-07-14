FROM ubuntu:22.04

# Sets an environment variable for the game to install.
# Supported games: valve, cstrike, czero, dod, dmc, gearbox, ricochet, tfc
# Default is valve. This get replaced when building the image with --build-arg GAME=<game>
ARG GAME=valve
ENV GAME ${GAME}

ARG APP_ID=70
ENV APP_ID ${APP_ID}

# Use a RUN command with a shell case statement to conditionally set APP_ID based on the value of GAME
RUN case "$GAME" in \
    tf) echo "APP_ID=232250" >> /etc/environment ;; \
    dods) echo "APP_ID=232290" >> /etc/environment ;; \
    *) echo "APP_ID=90" >> /etc/environment ;; \
    esac

# Apply the /etc/environment file to set the APP_ID environment variable
RUN echo 'source /etc/environment' >> $HOME/.bashrc

LABEL vendor="jives.dev" \
    maintainer="James Ives"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl rsync file lib32z1 libncurses5:i386 libbz2-1.0:i386 lib32gcc-s1 lib32stdc++6 libtinfo5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 ca-certificates && \
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

WORKDIR /opt/steam/hlds

COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh
COPY --chown=steam:steam config $GAME
COPY --chown=steam:steam mods .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]