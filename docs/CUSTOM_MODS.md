# Custom Mods

If you want to run a custom mod, you can do so with the `mods` directory.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, please refer back to it to get started.

1. Create a folder called `mods` that lives alongside where you run either the `docker run` or `docker compose up` command. If you cloned the project repository these will already exist.
2. Add your mod files as a sub-directory of `mods`. For example if the mod name is `decay`, you'd place it in `mods/decay`.
3. Define the `GAME` environment variable so it points to your mod name. This is what the dedicated server client will use to ensure that it starts a server for the correct mod. The name of the mod corresponds with the directory name that houses your mod.

```bash
export GAME=decay
```

4. Start the image. Most Half-Life mods require _specific_ startup arguments, refer to the [Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server) and the instructions for the mod you're trying to run for more details. You can find details about how to add these above. For Half-Life mods you'll most likely want to use the `valve` image, but this ultimately depends on the mod.

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
