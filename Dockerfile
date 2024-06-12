# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Define variables for the username, volume directory, and game
ENV USERNAME=steam
ENV VOLUME_DIR=src
ENV GAME=cstrike

# Update the base image and install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl file libc6:i386 lib32stdc++6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create a user and group for Steam
RUN groupadd -r $USERNAME && \
    useradd -r -g $USERNAME -m -d /opt/$USERNAME $USERNAME

# Create a directory for the game using the VOLUME_DIR variable
RUN mkdir /$VOLUME_DIR

# Switch to the Steam user
USER $USERNAME

# Set the working directory
WORKDIR /opt/$USERNAME

# Copy the installation script for the game
COPY ./hlds.txt /opt/$USERNAME

# Download SteamCMD and install the game
RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/$USERNAME/linux32/steamcmd && \
    ./steamcmd.sh +runscript hlds.txt

# Fix the error that steamclient.so is missing
RUN mkdir -p $HOME/.steam && \
    ln -s /opt/$USERNAME/linux32 $HOME/.steam/sdk32 && \
    echo 70 > /opt/$USERNAME/$GAME/steam_appid.txt

# Set the working directory for the game
WORKDIR /opt/$USERNAME/$GAME