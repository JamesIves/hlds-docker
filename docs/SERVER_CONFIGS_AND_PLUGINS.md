# Configs and Plugins

If you wish to add server configurations, such as add-ons, plugins, map rotations, etc, you can add them to the `config` directory.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, [please refer back to it to get started](../README.md).

Any configuration files will be copied into the container on start from the `config` directory and placed within the folder for the specified game. For example, if you set the game as `cstrike`, the contents of the `config` folder will be placed within the `cstrike` directory on the server.

1. Create a folder called `config` that lives alongside where you would normally start the server process.
2. Add your config files to the directory. For example you may want to add a `mapcycle.txt` file or a custom `motd.txt`.
3. Start the image as you normally would either with `docker run` or `docker compose up`.

For a list of all the available server configuration types, [refer to the Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Main_Page).
