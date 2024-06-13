# Half-Life Dedicated Server With Docker

<img align="right" width="120" height="auto"  src="./.github/docs/crowbar.png" alt="Crowbar">

Creates a [Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) instance using [Docker](https://www.docker.com). You can configure the server client however you'd like, and for any official games that are supported by the Half-Life Dedicated Server client.

## Setup ⚙️

Ensure you have the [Docker daemon installed and running](https://www.docker.com/), along with the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/).

> [!IMPORTANT]  
> The following steps will not work if you're using a system running on ARM or Mac Silicone architecture. Running via a Linux distribution is recommended.

### Building an Image

1. Define the game you want the server to run. You can do this by setting an environment variable on your command line.

```bash
export GAME=cstrike
```

Before continuing to the next steps verify that the environment variable is set by running `echo $GAME` in your terminal, it should send back the variable you just set.

> [!TIP]  
> Possible options include Half-Life Deathmatch (`valve`), Counter-Strike (`cstrike`), Counter-Strike Condition Zero (`czero`), Deathmatch Classic (`dmc`), Half-Life Opposing Force (`gearbox`), Ricochet (`ricochet`), Day of Defeat (`dod`), and Team Fortress Classic (`tfc`).

2. Clone the repository locally and build the image.

```sh
docker compose build
```

3. If you want to modify the server startup arguments, you can provide a `command` property within `docker-compose.yml`. [For a list of available arguments visit the Valve Developer Wiki](https://developer.valvesoftware.com/).

```yml
services:
  hlds:
    command: +maxplayers 16 +map cs_italy
```

4. Start the image. Once the Half-Life Dedicated Server client starts you'll begin to get a stream of messages from it.

```bash
docker compose up
```

5. Connect to your server snd start playing. ⌨️

### Pre-Built Images

If you prefer not to build the image yourself, you can follow the steps below to use a pre-built image on [Docker Hub](https://hub.docker.com/).

> [!NOTE]  
> For these steps you don't need to clone this project locally.

1. Similar to the build step, define an environment variable for the game you want your server to run.

```bash
export GAME=cstrike
```

2. Create a `docker-compose.yml` file. Adjust the `image` property so the tag name corresponds with the game you want to use. For example, `jives/hlds:cstrike` for Counter-Strike, and `jives/hlds:valve` for Half-Life.

```yml
version: "3.7"

services:
  hlds:
    environment:
      GAME: ${GAME}
    build: docker
    image: jives/hlds:cstrike
    volumes:
      - "./config:/config"
    ports:
      - "27015:27015/udp"
    command: +maxplayers 12 +map cs_italy +log on
```

3. Run `docker compose up`
4. Connect to your server snd start playing. ⌨️

## Server Configuration 🔧

If you wish to define server configurations, such as addons, plugins, map rotations, etc, you can add them to the `config` directory. These will be copied into the container on build and placed within the folder for the specified game. For example if you set the game as cstrike, the contents of config will be placed within the cstrike directory on the server.

Additionally you can make any server customizations by building the images manually and making adjustments directly to the `Dockerfile`. This may be useful if you're trying to run a custom mod such as Sven Coop, Natural Selection, etc.
