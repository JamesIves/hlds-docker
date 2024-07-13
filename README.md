<img align="right" width="180" height="auto"  src="./.github/docs/docker.svg" alt="Crowbar">

# Half-Life Dedicated Server With Docker

[Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) powered by [Docker](https://www.docker.com). Supports all the classic Half-Life games and mods, including the ability to add custom configurations and plugins.

Special thank you to all the past and present [GitHub Sponsors](https://github.com/sponsors/JamesIves) 💖.

<!-- sponsors --><a href="https://github.com/Chooksta69"><img src="https://github.com/Chooksta69.png" width="25px" alt="Chooksta69" /></a>&nbsp;&nbsp;<a href="https://github.com/MattWillFlood"><img src="https://github.com/MattWillFlood.png" width="25px" alt="MattWillFlood" /></a>&nbsp;&nbsp;<a href="https://github.com/jonathan-milan-pollock"><img src="https://github.com/jonathan-milan-pollock.png" width="25px" alt="jonathan-milan-pollock" /></a>&nbsp;&nbsp;<a href="https://github.com/raoulvdberge"><img src="https://github.com/raoulvdberge.png" width="25px" alt="raoulvdberge" /></a>&nbsp;&nbsp;<a href="https://github.com/robjtede"><img src="https://github.com/robjtede.png" width="25px" alt="robjtede" /></a>&nbsp;&nbsp;<a href="https://github.com/hadley"><img src="https://github.com/hadley.png" width="25px" alt="hadley" /></a>&nbsp;&nbsp;<a href="https://github.com/kevinchalet"><img src="https://github.com/kevinchalet.png" width="25px" alt="kevinchalet" /></a>&nbsp;&nbsp;<a href="https://github.com/Yousazoe"><img src="https://github.com/Yousazoe.png" width="25px" alt="Yousazoe" /></a>&nbsp;&nbsp;<a href="https://github.com/github"><img src="https://github.com/github.png" width="25px" alt="github" /></a>&nbsp;&nbsp;<a href="https://github.com/annegentle"><img src="https://github.com/annegentle.png" width="25px" alt="annegentle" /></a>&nbsp;&nbsp;<a href="https://github.com/planetoftheweb"><img src="https://github.com/planetoftheweb.png" width="25px" alt="planetoftheweb" /></a>&nbsp;&nbsp;<a href="https://github.com/melton1968"><img src="https://github.com/melton1968.png" width="25px" alt="melton1968" /></a>&nbsp;&nbsp;<a href="https://github.com/szepeviktor"><img src="https://github.com/szepeviktor.png" width="25px" alt="szepeviktor" /></a>&nbsp;&nbsp;<a href="https://github.com/sckott"><img src="https://github.com/sckott.png" width="25px" alt="sckott" /></a>&nbsp;&nbsp;<a href="https://github.com/provinzkraut"><img src="https://github.com/provinzkraut.png" width="25px" alt="provinzkraut" /></a>&nbsp;&nbsp;<a href="https://github.com/electrovir"><img src="https://github.com/electrovir.png" width="25px" alt="electrovir" /></a>&nbsp;&nbsp;<a href="https://github.com/Griefed"><img src="https://github.com/Griefed.png" width="25px" alt="Griefed" /></a>&nbsp;&nbsp;<!-- sponsors -->

## Setup ⚙️

Before starting, ensure you have the [Docker daemon](https://www.docker.com/) and the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/) installed and available.

> [!IMPORTANT]  
> The following steps will not work if you use an ARM architecture system. For best results, use a system running x86-64.

To get started as quickly as possible you can run the following in your terminal. Be sure to adjust the image name (`jives/hlds`) so the tag corresponds with the game you want to start the server for. Additionally you can adjust the server startup arguments by modifying the `command` property; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

```bash
$ docker run -d \
  --name hlds \
  -v "$(pwd)/config:/temp/config" \
  -v "$(pwd)/mods:/temp/mods" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  -p 26900:2690/udp \
  jives/hlds:cstrike \
  +maxplayers 12 +map cs_italy
```

> [!TIP]  
> You can find the available images below. You'll need to customize
>
> - `jives/hlds:valve` ([Half-Life Deathmatch](https://store.steampowered.com/app/70/HalfLife/))
> - `jives/hlds:cstrike` ([Counter-Strike](https://store.steampowered.com/app/10/CounterStrike/))
> - `jives/hlds:czero` ([Counter-Strike Condition Zero](https://store.steampowered.com/app/80/CounterStrike_Condition_Zero/))
> - `jives/hlds:dmc` ([Deathmatch Classic](https://store.steampowered.com/app/40/Deathmatch_Classic/))
> - `jives/hlds:gearbox` ([Half-Life Opposing Force](https://store.steampowered.com/app/50/HalfLife_Opposing_Force/))
> - `jives/hlds:ricohet` ([Ricochet](https://store.steampowered.com/app/60/Ricochet/))
> - `jives/hlds:dod` ([Day of Defeat](https://store.steampowered.com/app/30/Day_of_Defeat/))
> - `jives/hlds:tfc` ([Team Fortress Classic](https://store.steampowered.com/app/20/Team_Fortress_Classic/))

If you'd prefer to use docker compose you can create a `docker-compose.yml` file with the following and run `docker compose up`.

```yml
services:
  hlds:
    build: docker
    # 📣 Adjust the image value here with the desired game you want the server to use.
    image: jives/hlds:cstrike
    volumes:
      - "./config:/temp/config"
      - "./mods:/temp/mods"
    ports:
      - "27015:27015/udp"
      - "27015:27015"
      - "26900:2690/udp"
    environment:
      - GAME=${GAME}
    # 📣 Modify your server startup commands here.
    # 📣 Remember: Stating map is based on the game, and will likely be different between images.
    command: +maxplayers 12 +map cs_italy
```

Once the Half-Life Dedicated Server client starts, you'll receive a stream of messages, including the server's public IP address and any startup errors. Connect to your server via the IP address by loading the game on Steam and start playing. You must own a copy of the game on Steam in order to play.

## Advanced Setup

The following guides show some common setup guides.

- Building a Custom Image
- Custom Configs and Plugins
- Custom Mods
