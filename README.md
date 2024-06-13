# Half-Life Dedicated Server With Docker

<img align="right" width="120" height="auto"  src="./.github/docs/crowbar.png" alt="Crowbar">

Creates a [Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) instance using [Docker](https://www.docker.com). You can configure the server client however you'd like, and for any official games that are supported by the Half-Life Dedicated Server client.

## Setup ⚙️

Ensure you have the [Docker daemon installed and running](https://www.docker.com/), along with the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/).

> [!IMPORTANT]  
> The following steps will not work if you're using a system running on ARM or Mac Silicone architecture. Running via a Linux distribution is recommended.

1. Define the game you want to start the server for. You can do this by setting an environment variable on your command line.

```bash
export GAME=cstrike
```

Before continuing to the next steps verify that the environment variable is set by running `echo $GAME` in your terminal.

> [!TIP]  
> Possible options include Half-Life Deathmatch (`valve`), Counter-Strike (`cstrike`), Counter-Strike Condition Zero (`czero`), Deathmatch Classic (`dmc`), Opposing Force (`gearbox`), Ricochet (`ricochet`), Day of Defeat (`dod`), and Team Fortress Classic (`tfc`).

2. Build the image.

```sh
docker compose build
```

3. If you want to modify the server startup arguments, you can provide a `command` property. [For a list of available arguments visit the Valve Developer Wiki](https://developer.valvesoftware.com/).

```yml
services:
  hlds:
    command: +maxplayers 16 +map cs_italy
```

4. Start the image. Once HLDS starts you'll get logging messages about the public ip etc.

```bash
docker compose up
```

## Server Configuration 🔧

If you wish to define server configurations, such as addons, plugins, custom message of the days, map rotations, etc, you can add them to the `config` directory. These will be copied into the container on startup of your server.
