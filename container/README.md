# Building an Image

If you want to build an image yourself, follow the steps below. This can be useful in cases where you want to make changes to the build scripts or add custom functionality. It is also useful for testing changes before submitting a contribution to the project.

1. Clone this project locally.
2. Define the game you want the server to run. You can do this by setting an environment variable on your command line.

```bash
export GAME=cstrike
```

Before continuing to the following steps, verify that the environment variable is set by running `echo $GAME` in your terminal. It should send back the variable you just set.

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
>
> To install a specific sub version, such as a beta, you can utilize the `FLAGS` environment variable to pass arbitrary command flags to Steam CMD. For example, `export FLAGS=-beta steam_legacy`.

3. Navigate to the `container` folder (where this README file is) and build the image.

```sh
docker compose build
```

4. If you want to modify the server startup arguments, you can provide a `command` property within `docker-compose.yml`; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

> [!NOTE]  
> In most cases, you'll need to specify `+map` for the server to be joinable.

```yml
services:
  hlds:
    command: +maxplayers 16 +map cs_italy
```

5. Start the image. Once the Half-Life Dedicated Server client starts, you'll receive a stream of messages, including the server's public IP address and any startup errors.

```bash
docker compose up
```

6. Connect to your server via the public IP address by loading the game on [Steam](https://store.steampowered.com/). To play, you must own a copy of the game on Steam.
7. _Optional_: If you want to start a custom mod, you can modify your `$GAME` environment variable once the image is built before running `docker compose up`. This allows you to add custom scripts to the server image while telling the dedicated server client what mod to use. If you're building a custom image with the intent on playing a custom mod it's recommended that you set the `$GAME` variable to `valve` for the initial build.

```bash
$export GAME=valve
$ docker compose build
$export GAME=decay
$ docker compose up
```
