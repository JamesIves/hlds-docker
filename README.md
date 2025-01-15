# hlds-docker

<img align="right" width="180" height="auto"  src="./.github/docs/docker.svg" alt="Docker in the Half-Life Colours">

[Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) powered by [Docker](https://www.docker.com). It supports all the classic [GoldSrc](https://developer.valvesoftware.com/wiki/GoldSrc) Half-Life games and mods, including the ability to add custom configurations and plugins.

Special thank you to all the past and present [GitHub Sponsors](https://github.com/sponsors/JamesIves) 💖.

<!-- sponsors --><a href="https://github.com/Chooksta69"><img src="https:&#x2F;&#x2F;github.com&#x2F;Chooksta69.png" width="25px" alt="Chooksta69" /></a>&nbsp;&nbsp;<a href="https://github.com/MattWillFlood"><img src="https:&#x2F;&#x2F;github.com&#x2F;MattWillFlood.png" width="25px" alt="MattWillFlood" /></a>&nbsp;&nbsp;<a href="https://github.com/jonathan-milan-pollock"><img src="https:&#x2F;&#x2F;github.com&#x2F;jonathan-milan-pollock.png" width="25px" alt="jonathan-milan-pollock" /></a>&nbsp;&nbsp;<a href="https://github.com/raoulvdberge"><img src="https:&#x2F;&#x2F;github.com&#x2F;raoulvdberge.png" width="25px" alt="raoulvdberge" /></a>&nbsp;&nbsp;<a href="https://github.com/robjtede"><img src="https:&#x2F;&#x2F;github.com&#x2F;robjtede.png" width="25px" alt="robjtede" /></a>&nbsp;&nbsp;<a href="https://github.com/hadley"><img src="https:&#x2F;&#x2F;github.com&#x2F;hadley.png" width="25px" alt="hadley" /></a>&nbsp;&nbsp;<a href="https://github.com/kevinchalet"><img src="https:&#x2F;&#x2F;github.com&#x2F;kevinchalet.png" width="25px" alt="kevinchalet" /></a>&nbsp;&nbsp;<a href="https://github.com/Yousazoe"><img src="https:&#x2F;&#x2F;github.com&#x2F;Yousazoe.png" width="25px" alt="Yousazoe" /></a>&nbsp;&nbsp;<a href="https://github.com/github"><img src="https:&#x2F;&#x2F;github.com&#x2F;github.png" width="25px" alt="github" /></a>&nbsp;&nbsp;<a href="https://github.com/annegentle"><img src="https:&#x2F;&#x2F;github.com&#x2F;annegentle.png" width="25px" alt="annegentle" /></a>&nbsp;&nbsp;<a href="https://github.com/planetoftheweb"><img src="https:&#x2F;&#x2F;github.com&#x2F;planetoftheweb.png" width="25px" alt="planetoftheweb" /></a>&nbsp;&nbsp;<a href="https://github.com/melton1968"><img src="https:&#x2F;&#x2F;github.com&#x2F;melton1968.png" width="25px" alt="melton1968" /></a>&nbsp;&nbsp;<a href="https://github.com/szepeviktor"><img src="https:&#x2F;&#x2F;github.com&#x2F;szepeviktor.png" width="25px" alt="szepeviktor" /></a>&nbsp;&nbsp;<a href="https://github.com/sckott"><img src="https:&#x2F;&#x2F;github.com&#x2F;sckott.png" width="25px" alt="sckott" /></a>&nbsp;&nbsp;<a href="https://github.com/provinzkraut"><img src="https:&#x2F;&#x2F;github.com&#x2F;provinzkraut.png" width="25px" alt="provinzkraut" /></a>&nbsp;&nbsp;<a href="https://github.com/electrovir"><img src="https:&#x2F;&#x2F;github.com&#x2F;electrovir.png" width="25px" alt="electrovir" /></a>&nbsp;&nbsp;<a href="https://github.com/Griefed"><img src="https:&#x2F;&#x2F;github.com&#x2F;Griefed.png" width="25px" alt="Griefed" /></a>&nbsp;&nbsp;<a href="https://github.com/MontezumaIves"><img src="https:&#x2F;&#x2F;github.com&#x2F;MontezumaIves.png" width="25px" alt="MontezumaIves" /></a>&nbsp;&nbsp;<a href="https://github.com/tonjohn"><img src="https:&#x2F;&#x2F;github.com&#x2F;tonjohn.png" width="25px" alt="tonjohn" /></a>&nbsp;&nbsp;<a href="https://github.com/wylie"><img src="https:&#x2F;&#x2F;github.com&#x2F;wylie.png" width="25px" alt="wylie" /></a>&nbsp;&nbsp;<a href="https://github.com/pylapp"><img src="https:&#x2F;&#x2F;github.com&#x2F;pylapp.png" width="25px" alt="pylapp" /></a>&nbsp;&nbsp;<a href="https://github.com/"><img src="https:&#x2F;&#x2F;raw.githubusercontent.com&#x2F;JamesIves&#x2F;github-sponsors-readme-action&#x2F;dev&#x2F;.github&#x2F;assets&#x2F;placeholder.png" width="25px" alt="" /></a>&nbsp;&nbsp;<a href="https://github.com/"><img src="https:&#x2F;&#x2F;raw.githubusercontent.com&#x2F;JamesIves&#x2F;github-sponsors-readme-action&#x2F;dev&#x2F;.github&#x2F;assets&#x2F;placeholder.png" width="25px" alt="" /></a>&nbsp;&nbsp;<a href="https://github.com/"><img src="https:&#x2F;&#x2F;raw.githubusercontent.com&#x2F;JamesIves&#x2F;github-sponsors-readme-action&#x2F;dev&#x2F;.github&#x2F;assets&#x2F;placeholder.png" width="25px" alt="" /></a>&nbsp;&nbsp;<!-- sponsors -->

## Getting Started 🚀

Before starting, ensure you have the [Docker daemon](https://www.docker.com/) and the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/) installed and available.

> [!IMPORTANT]  
> The following steps will not work if you use an ARM architecture system. For best results, use a system running x86-64.

You can run the following in your terminal to get started as quickly as possible. Adjust the image name (`jives/hlds`) so the tag corresponds with the game you want to use. Additionally, you can adjust the server startup arguments by modifying the `command` property; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

```bash
docker run -d -ti \
  --name hlds \
  -v "$(pwd)/config:/temp/config" \
  -v "$(pwd)/mods:/temp/mods" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  -p 26900:26900/udp \
  jives/hlds:valve  \
  "+log on +rcon_password changeme +maxplayers 12 +map crossfire" # 📣 Modify your server startup commands here. You can specify the image with the desired game you want the server to run in the line above.
```

> [!TIP]  
> The available images are below. When changing the game, be sure to adjust the `+map` parameter, as it may cause the server to not be joinable if the map is unavailable.
>
> - `jives/hlds:valve` ([Half-Life Deathmatch](https://store.steampowered.com/app/70/HalfLife/))
> - `jives/hlds:cstrike` ([Counter-Strike](https://store.steampowered.com/app/10/CounterStrike/))
> - `jives/hlds:czero` ([Counter-Strike Condition Zero](https://store.steampowered.com/app/80/CounterStrike_Condition_Zero/))
> - `jives/hlds:dmc` ([Deathmatch Classic](https://store.steampowered.com/app/40/Deathmatch_Classic/))
> - `jives/hlds:gearbox` ([Half-Life Opposing Force](https://store.steampowered.com/app/50/HalfLife_Opposing_Force/))
> - `jives/hlds:ricohet` ([Ricochet](https://store.steampowered.com/app/60/Ricochet/))
> - `jives/hlds:dod` ([Day of Defeat](https://store.steampowered.com/app/30/Day_of_Defeat/))
> - `jives/hlds:tfc` ([Team Fortress Classic](https://store.steampowered.com/app/20/Team_Fortress_Classic/))
> - `jives/hlds:valve-legacy` ([Half-Life Deathmatch](https://store.steampowered.com/app/70/HalfLife/)) ([Pre-25th Anniversary Build](https://www.half-life.com/en/halflife25))
> - `jives/hlds:cstrike-legacy` ([Counter-Strike](https://store.steampowered.com/app/10/CounterStrike/)) ([Pre-25th Anniversary Build](https://www.half-life.com/en/halflife25))
> - `jives/hlds:czero-legacy` ([Counter-Strike Condition Zero](https://store.steampowered.com/app/80/CounterStrike_Condition_Zero/)) ([Pre-25th Anniversary Build](https://www.half-life.com/en/halflife25))
>
> Container images are published on [Docker Hub](https://hub.docker.com/repository/docker/jives/hlds/general) and the [GitHub Container Registry](https://github.com/JamesIves/hlds-docker/pkgs/container/hlds).

Once the command finishes, you can connect to your server via the public IP address by loading the game on [Steam](https://steampowered.com). **You must own a copy of the game on Steam to play**.

> [!NOTE]  
> If you cannot join the server, you can check for errors in the server logs by running `docker ps` to get the container id followed by `docker logs <container id>`.

### Docker Compose

If you'd prefer to configure your server using [Docker Compose](https://docs.docker.com/compose/), you can pull down the project repository to your system and run `docker compose up` from the root. Make any modifications you need, such as changing the game image and server startup commands in [docker-compose.yml](docker-compose.yml) before running `docker compose up`.

## Advanced Setup ⚙️

To customize the server client further, please check out the following advanced setup guides.

- [Server Configs and Plugins](config/README.md)
- [Custom Mods](mods/README.md)
- [Building a Custom Image](container/README.md)
