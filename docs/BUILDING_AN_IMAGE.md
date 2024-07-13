# Building an Image

If you want to build an image yourself, you can follow the steps below. This can be useful in cases where you want to make changes to the build scripts, or add custom functionality. This is also useful for testing changes before submitting a contribution to the project.

1. Clone this project locally.
2. Define the game you want the server to run. You can do this by setting an environment variable on your command line.

```bash
export GAME=cstrike
```

Before continuing to the next steps, verify that the environment variable is set by running `echo $GAME` in your terminal. It should send back the variable you just set.

> [!TIP]
> Available options include the following, these names are recognized by the `app_set_config 90 mod` command in `hlds.txt`.
>
> - `valve` ([Half-Life Deathmatch](https://store.steampowered.com/app/70/HalfLife/))
> - `cstrike` ([Counter-Strike](https://store.steampowered.com/app/10/CounterStrike/))
> - `czero` ([Counter-Strike Condition Zero](https://store.steampowered.com/app/80/CounterStrike_Condition_Zero/))
> - `dmc` ([Deathmatch Classic](https://store.steampowered.com/app/40/Deathmatch_Classic/))
> - `gearbox` ([Half-Life Opposing Force](https://store.steampowered.com/app/50/HalfLife_Opposing_Force/))
> - `ricohet` ([Ricochet](https://store.steampowered.com/app/60/Ricochet/))
> - `dod` ([Day of Defeat](https://store.steampowered.com/app/30/Day_of_Defeat/))
> - `tfc` ([Team Fortress Classic](https://store.steampowered.com/app/20/Team_Fortress_Classic/))

3. Build the image.

```sh
docker compose -f docker-compose.local.yml build
```

4. If you want to modify the server startup arguments, you can provide a `command` property within `docker-compose.local.yml`; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

> [!NOTE]  
> In the majority of cases you'll need to specify `+map` for the server to be joinable.

```yml
services:
  hlds:
    command: +maxplayers 16 +map cs_italy
```

5. Start the image. Once the Half-Life Dedicated Server client starts, you'll receive a stream of messages, including the server's public IP address and any startup errors.

```bash
docker compose -f docker-compose.local.yml up
```

6. Connect to your server via the IP address by loading the game on [Steam](https://store.steampowered.com/) and start playing. You must own a copy of the game on Steam in order to play. ⌨️
7. _Optional_: If you want to start a custom mod, you can modify your `$GAME` environment variable once the image is built prior to running `docker compose -f docker-compose.local.yml up`. This allows you to add custom scripts to the server image while also telling the dedicated server client what mod to use.
