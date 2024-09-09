# hlds-docker

<img align="right" width="180" height="auto"  src="./.github/docs/docker.svg" alt="Docker in the Half-Life Colours">

[Half-Life Dedicated Server](https://help.steampowered.com/en/faqs/view/081A-106F-B906-1A7A) powered by [Docker](https://www.docker.com). It supports all the classic [GoldSrc](https://developer.valvesoftware.com/wiki/GoldSrc) Half-Life games and mods, including the ability to add custom configurations and plugins.

Special thank you to all the past and present [GitHub Sponsors](https://github.com/sponsors/JamesIves) 💖.

<!-- sponsors --><a href="https://github.com/Chooksta69"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;64383803?v&#x3D;4" width="25px" alt="Chooksta69" /></a>&nbsp;&nbsp;<a href="https://github.com/MattWillFlood"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;56543497?u&#x3D;1be6fe938a7cdd414907bf0d2598e378783873f3&amp;v&#x3D;4" width="25px" alt="MattWillFlood" /></a>&nbsp;&nbsp;<a href="https://github.com/jonathan-milan-pollock"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;29420046?u&#x3D;4abd4069b4fef966d4ce3f6fbff4f14f2bc6080f&amp;v&#x3D;4" width="25px" alt="jonathan-milan-pollock" /></a>&nbsp;&nbsp;<a href="https://github.com/raoulvdberge"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;10358424?u&#x3D;fccabb4473476bf181b78f7442ec904cd6c7abee&amp;v&#x3D;4" width="25px" alt="raoulvdberge" /></a>&nbsp;&nbsp;<a href="https://github.com/robjtede"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;3316789?u&#x3D;5b6d5b45b7a2755584d2c57ecabf56f3eb292e21&amp;v&#x3D;4" width="25px" alt="robjtede" /></a>&nbsp;&nbsp;<a href="https://github.com/hadley"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;4196?u&#x3D;381fe2cce7ecc86993a19168bcf6638e9805326a&amp;v&#x3D;4" width="25px" alt="hadley" /></a>&nbsp;&nbsp;<a href="https://github.com/kevinchalet"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;6998306?u&#x3D;71c40a231984c198d230974e6536b1aea5caf756&amp;v&#x3D;4" width="25px" alt="kevinchalet" /></a>&nbsp;&nbsp;<a href="https://github.com/Yousazoe"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;58163275?u&#x3D;53e8c48f203d62424b0497a84851d9546328e518&amp;v&#x3D;4" width="25px" alt="Yousazoe" /></a>&nbsp;&nbsp;<a href="https://github.com/github"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;9919?v&#x3D;4" width="25px" alt="github" /></a>&nbsp;&nbsp;<a href="https://github.com/annegentle"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;501981?u&#x3D;155ca47d6829300d17a5454f0839f341424ecf8d&amp;v&#x3D;4" width="25px" alt="annegentle" /></a>&nbsp;&nbsp;<a href="https://github.com/planetoftheweb"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;216426?u&#x3D;f1a819a7d5f75b8034c122cbdba7bdcb38d0e1c9&amp;v&#x3D;4" width="25px" alt="planetoftheweb" /></a>&nbsp;&nbsp;<a href="https://github.com/melton1968"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;976548?v&#x3D;4" width="25px" alt="melton1968" /></a>&nbsp;&nbsp;<a href="https://github.com/szepeviktor"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;952007?u&#x3D;18bbc00cedf197bc543f479b4e39f09c0260ca3d&amp;v&#x3D;4" width="25px" alt="szepeviktor" /></a>&nbsp;&nbsp;<a href="https://github.com/sckott"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;577668?u&#x3D;c54eb1ce08ff22365e094559a109a12437bdca40&amp;v&#x3D;4" width="25px" alt="sckott" /></a>&nbsp;&nbsp;<a href="https://github.com/provinzkraut"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;25355197?u&#x3D;634fd238d93f44c6f522dda72068fc82941564c4&amp;v&#x3D;4" width="25px" alt="provinzkraut" /></a>&nbsp;&nbsp;<a href="https://github.com/electrovir"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;1205860?u&#x3D;61c2513bc24ecc2a909817adc701746b94fed939&amp;v&#x3D;4" width="25px" alt="electrovir" /></a>&nbsp;&nbsp;<a href="https://github.com/Griefed"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;44273438?u&#x3D;b44cb19075c1a93904507a69067fc55bc66360a9&amp;v&#x3D;4" width="25px" alt="Griefed" /></a>&nbsp;&nbsp;<a href="https://github.com/MontezumaIves"><img src="https:&#x2F;&#x2F;avatars.githubusercontent.com&#x2F;u&#x2F;78580739?u&#x3D;b65aecfacc32ed08463bd50dae61d8a048f618ec&amp;v&#x3D;4" width="25px" alt="MontezumaIves" /></a>&nbsp;&nbsp;<a href="https://github.com/"><img src="https:&#x2F;&#x2F;raw.githubusercontent.com&#x2F;JamesIves&#x2F;github-sponsors-readme-action&#x2F;dev&#x2F;.github&#x2F;assets&#x2F;placeholder.png" width="25px" alt="" /></a>&nbsp;&nbsp;<a href="https://github.com/"><img src="https:&#x2F;&#x2F;raw.githubusercontent.com&#x2F;JamesIves&#x2F;github-sponsors-readme-action&#x2F;dev&#x2F;.github&#x2F;assets&#x2F;placeholder.png" width="25px" alt="" /></a>&nbsp;&nbsp;<!-- sponsors -->

## Getting Started 🚀

Before starting, ensure you have the [Docker daemon](https://www.docker.com/) and the [Docker CLI tool](https://docs.docker.com/engine/reference/commandline/cli/) installed and available.

> [!IMPORTANT]  
> The following steps will not work if you use an ARM architecture system. For best results, use a system running x86-64.

You can run the following in your terminal to get started as quickly as possible. Adjust the image name (`jives/hlds`) so the tag corresponds with the game you want to use. Additionally, you can adjust the server startup arguments by modifying the `command` property; [for a list of available arguments, visit the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server).

```bash
docker run -d \
  --name hlds \
  -v "$(pwd)/config:/temp/config" \
  -v "$(pwd)/mods:/temp/mods" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  -p 26900:26900/udp \
  -e GAME=${GAME} \
  jives/hlds:valve  \
  "+log on +rcon_password changeme +maxplayers 12 +map crossfire" # 📣 Modify your server startup commands here. You can specify the image with the desired game you want the server to run in the line above.
```

> [!TIP]  
> The available images are below. When changing the game, be sure to adjust the `+map` parameter, as it may cause the server not to be joinable if the map is unavailable.
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
> Container images are alternatively available on the [GitHub Container Registry](https://github.com/JamesIves/hlds-docker/pkgs/container/hlds).

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
