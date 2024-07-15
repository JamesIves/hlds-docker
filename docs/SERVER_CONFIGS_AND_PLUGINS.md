# Configs and Plugins

If you wish to add server configurations, such as add-ons, plugins, map rotations, etc, you can add them to the `config` directory.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, [please refer back to it to get started](../README.md).

Any configuration files will be copied into the container on start from the `config` directory and placed within the folder for the specified game. For example, if you set the game as `cstrike`, the contents of the `config` folder will be placed within the `cstrike` directory on the server.

> [!TIP]  
> As an example if you have `config/mapcycle.txt`, on the server that will be placed in the `hlds/cstrike/mapcycle.txt` directory which is where the Half-Life Dedicated Server client expects these types of files to be placed. You can use this to install server plugins such as AMX Mod, Meta Mod, etc, as the directory can handle nested folders too, for example these can be placed in `config/addons/amxmodx` etc.

1. Create a folder called `config` that lives alongside where you would typically start the server process.
2. Add your config files to the directory.
3. Start the image as you normally would, either with `docker run` or `docker compose up`.

For a list of all the available server configuration types, [refer to the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Main_Page).
