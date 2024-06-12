#!/usr/bin/env sh

if [ -d /tmp/$CONFIG_DIR ]
then
  rsync --chown=steam:steam /tmp/$CONFIG_DIR/* /opt/steam/$INSTALL_DIR/$MOD
fi

echo Starting server...

./hlds_linux "$@"