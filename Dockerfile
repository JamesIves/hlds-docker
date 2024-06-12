# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Define variables for the username and volume directory
ENV USERNAME=steam
ENV VOLUME_DIR=src

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

# Copy the installation script for HLDM
COPY ./hldm.install /opt/$USERNAME

# Download SteamCMD and install HLDM
RUN curl -v -sL media.steampowered.com/client/installer/steamcmd_linux.tar.gz | tar xzvf - && \
    file /opt/$USERNAME/linux32/steamcmd && \
    ./steamcmd.sh +runscript hldm.install

# Fix the error that steamclient.so is missing
RUN mkdir -p $HOME/.steam && \
    ln -s /opt/$USERNAME/linux32 $HOME/.steam/sdk32 && \
    echo 70 > /opt/$USERNAME/hldm/steam_appid.txt

# Set the working directory for HLDM
WORKDIR /opt/$USERNAME/hldm

# Copy configs, Metamod, Stripper2, and AMX
COPY --chown=$USERNAME:$USERNAME $VOLUME_DIR valve
COPY --chown=$USERNAME:$USERNAME ./entrypoint.sh ./entrypoint.sh

# Expose the necessary ports
EXPOSE 27015
EXPOSE 27015/udp

# Set the entrypoint for the server
ENTRYPOINT ["./entrypoint.sh", "-timeout 3"]

# Set the default start parameters
CMD ["+maxplayers 12", "+map crossfire"]

# Set labels for the image
LABEL vendor=steamcalculator.com \
    hldm.docker.version="$VERSION" \
    hldm.docker.release-date="$RELEASE_DATE"