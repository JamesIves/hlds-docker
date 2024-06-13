# Half-Life Dedicated Server With Docker 🐋

<img align="right" width="120" height="auto"  src="./.github/docs/crowbar.png" alt="Crowbar">

Creates a [Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) instance using [Docker](https://www.docker.com). You can run any games the Half-Life Dedicated Server client supports out of the box, including the ability to add custom configurations and plugins.

## Setup ⚙️

Before starting, ensure you have the [Docker daemon](https://www.docker.com/) and the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/) installed and available.

> [!IMPORTANT]  
> The following steps will not work if you use an ARM architecture system. For best results, use a system running x86-64.

### Building an Image

1. Clone this project.
2. Define the game you want the server to run. You can do this by setting an environment variable on your command line.

```bash
export GAME=cstrike
```

Before continuing to the next steps, verify that the environment variable is set by running `echo $GAME` in your terminal. It should send back the variable you just set.

> [!TIP]
> Available options include:
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
docker compose build
```

4. If you want to modify the server startup arguments, you can provide a command property within `docker-compose.yml`; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

```yml
services:
  hlds:
    command: +maxplayers 16 +map cs_italy
```

5. Start the image. Once the Half-Life Dedicated Server client starts, you'll receive a stream of messages, including the server's public IP address and any startup errors.

```bash
docker compose up
```

6. Connect to your server and start playing. ⌨️

### Pre-Built Images

If you prefer not to build the image, follow the steps below to use a pre-built image on [Docker Hub](https://hub.docker.com/).

1. Define an environment variable for the game you want your server to run.

```bash
export GAME=cstrike
```

2. Create a `docker-compose.yml` file. Adjust the image property so the tag name corresponds with the game you want to use.

```yml
version: "3.7"

services:
  hlds:
    environment:
      GAME: ${GAME}
    build: docker
    image: jives/hlds:cstrike # Adjust the image here with the desired game.
    volumes:
      - "./config:/config"
    ports:
      - "27015:27015/udp"
    command: +maxplayers 12 +map cs_italy +log on
```

> [!TIP]  
> Available images include:
>
> - `jives/hlds:valve` ([Half-Life Deathmatch](https://store.steampowered.com/app/70/HalfLife/))
> - `jives/hlds:cstrike` ([Counter-Strike](https://store.steampowered.com/app/10/CounterStrike/))
> - `jives/hlds:czero` ([Counter-Strike Condition Zero](https://store.steampowered.com/app/80/CounterStrike_Condition_Zero/))
> - `jives/hlds:dmc` ([Deathmatch Classic](https://store.steampowered.com/app/40/Deathmatch_Classic/))
> - `jives/hlds:gearbox` ([Half-Life Opposing Force](https://store.steampowered.com/app/50/HalfLife_Opposing_Force/))
> - `jives/hlds:ricohet` ([Ricochet](https://store.steampowered.com/app/60/Ricochet/))
> - `jives/hlds:dod` ([Day of Defeat](https://store.steampowered.com/app/30/Day_of_Defeat/))
> - `jives/hlds:tfc` ([Team Fortress Classic](https://store.steampowered.com/app/20/Team_Fortress_Classic/))

3. Start the image. Once the Half-Life Dedicated Server client starts, you'll receive a stream of messages, including the server's public IP address and any startup errors.

```bash
docker compose up
```

4. Connect to your server snd start playing. ⌨️

## Server Configuration 🔧

If you wish to add server configurations, such as add-ons, plugins, map rotations, etc, you can add them to the `config` directory. Any configuration files will be copied into the container on build and placed within the folder for the specified game. For example, if you set the game as `cstrike`, the contents of the config folder will be placed within the `cstrike` directory on the server.

Additionally, you can customize the server by manually building the images and making adjustments to the `Dockerfile`. This may be useful if you're trying to run a custom mod.

## Ownership 🧰

The Half-Life Dedicated Server client, Steam, SteamCMD and the titles themselves are property and ownership of [Valve Software](https://valvesoftware.com). All this tool does is make it easier to interface with their provided tooling.
