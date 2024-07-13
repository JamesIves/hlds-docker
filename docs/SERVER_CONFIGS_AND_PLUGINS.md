# Configs and Plugins

If you wish to add server configurations, such as add-ons, plugins, map rotations, etc, you can add them to the `config` directory.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, please refer back to it to get started.

Any configuration files will be copied into the container on start and placed within the folder for the specified game. For example, if you set the game as `cstrike`, the contents of the config folder will be placed within the `cstrike` directory on the server.

1. Create a folder called `config` that lives alongside where you run either the `docker run` or `docker compose up` command. If you cloned the project repository these will already exist.
2. Add your config files to the directory. For example you may want to add a `mapcycle.txt` file or a custom `motd.txt`.
3. Start the image as you normally would.

If you're using docker compose:

```bash
docker compose up
```

If you're not using docker compose:

```bash
$ docker run -d \
  --name hlds \
  -v "$(pwd)/config:/temp/config" \
  -v "$(pwd)/mods:/temp/mods" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  -p 26900:2690/udp \
  -e GAME=${GAME} \
  ghcr.io/jamesives/hlds:valve \
  +maxplayers 12 +map dy_accident1
```
