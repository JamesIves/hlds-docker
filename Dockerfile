# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Define variables for the username, volume directory, and game
ENV USERNAME=steam
ENV VOLUME_DIR=src
ENV GAME=cstrike

# Update the package list and install the necessary packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl file libc6:i386 lib32stdc++6 ca-certificates rsync && \
    rm -rf /var/lib/apt/lists/*

# Create a user for the SteamCMD and game
RUN groupadd -r $USERNAME && \
    useradd -r -g $USERNAME -m -d /opt/$USERNAME $USERNAME

# Create a directory for the game using the VOLUME_DIR variable
RUN mkdir /$VOLUME_DIR
USER $USERNAME
WORKDIR /opt/$USERNAME

# Copy the hlds.txt file to the container
COPY ./hlds.txt /opt/$USERNAME

# Download and install SteamCMD
RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/$USERNAME/linux32/steamcmd && \
    ./steamcmd.sh +force_install_dir ./$GAME +runscript hlds.txt

# Create a symbolic link to the Steam SDK
RUN mkdir -p $HOME/.steam && \
    ln -s /opt/$USERNAME/linux32 $HOME/.steam/sdk32 && \
    echo 70 > /opt/$USERNAME/$GAME/steam_appid.txt

# Expose the necessary ports for the game
WORKDIR /opt/$USERNAME/$GAME


# Copy configs, Metamod, Stripper2 and AMX.
COPY --chown=steam:steam $VOLUME_DIR valve
COPY --chown=steam:steam ./entrypoint.sh ./entrypoint.sh

EXPOSE 27015
EXPOSE 27015/udp

# Start server.
ENTRYPOINT ["./entrypoint.sh", "-timeout 3"]

# Default start parameters.
CMD ["+maxplayers 12", "+map crossfire"]

