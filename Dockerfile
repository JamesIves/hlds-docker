FROM ubuntu:22.04

# Sets an environment variable for the game to install.
# Supported games: valve, cstrike, czero, dod, dmc, gearbox, ricochet, tfc
# Default is valve. This get replaced when building the image with --build-arg GAME=<game>
ARG GAME=valve
ENV GAME ${GAME}

ARG APP_ID=70
ENV APP_ID ${APP_ID}

# # Use a RUN command with shell scripting to conditionally set APP_ID based on the value of GAME
# RUN if [ "$GAME" = "tf2" ]; then \
#     echo "ENV APP_ID=28804" > /etc/environment; \
#     elif [ "$GAME" = "dods" ]; then \
#     echo "ENV APP_ID=2222" > /etc/environment; \
#     else \
#     echo "ENV APP_ID=default_value" > /etc/environment; \
#     fi

# RUN echo 'source /etc/environment' >> $HOME/.bashrc

LABEL vendor="jives.dev" \
    maintainer="James Ives"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl rsync file lib32z1 libncurses5:i386 libbz2-1.0:i386 lib32gcc1 lib32stdc++6 libtinfo5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 ca-certificates && \
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