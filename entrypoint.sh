#!/usr/bin/env sh

if [ -d /tmp/$VOLUME_DIR ]
then
  rsync --chown=steam:steam /tmp/$VOLUME_DIR/* /opt/steam/$INSTALL_DIR/$MOD
fi

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"

echo Starting HLDS...
./hlds_linux "$@"