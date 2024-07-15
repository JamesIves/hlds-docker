# Configs and Plugins

If you wish to add server configurations, such as add-ons, plugins, map rotations, etc, you can add them to the `config` directory. The `config` directory is volume mapped within the directory for the game you're starting the container for. For example, if you're starting a container for `cstrike`, you can add things like `mapcycle.txt` or `motd.txt` here and it would appear within the corresponding `cstrike` directory on the server.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, [please refer back to it to get started](../../README.md).

```
├── hlds
│   ├── cstrike
│   │   ├── models
│   │   ├── maps
│   │   ├── mapcycle.txt
│   │   ├── motd.txt
```

> [!TIP]  
> You can use this method to install server plugins such as AMX Mod, Meta Mod, etc, as the directory can handle nested folders too, for example these can be placed in `config/addons/amxmodx` etc.

1. Create a folder called `config` that lives alongside where you would typically start the server process. If you've cloned this project locally, you'd place them alongside this README file.
2. Add your config files to the directory.
3. Start the image as you normally would, either with `docker run` or `docker compose up`.

For a list of all the available server configuration types, [refer to the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Main_Page).
