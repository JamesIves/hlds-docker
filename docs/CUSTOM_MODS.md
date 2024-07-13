# Custom Mods

If you want to run a custom mod, you can do so with the `mods` directory.

> [!NOTE]  
> The startup examples posted in the project README already have this directory volume mapped accordingly. If you've strayed from the suggested setup, [please refer back to it to get started](../README.md).

1. Create a folder called `mods` that lives alongside where you would normally start the server process.
2. Add your mod files as a sub-directory of `mods`. For example if the mod name is `decay`, you'd place it in `mods/decay`.
3. Define the `GAME` environment variable for your mod name. The dedicated server client will use this to ensure that it starts a server for the correct mod, which corresponds with the directory name that was just created.

```bash
export GAME=decay
```

4. Start the image as you normally would, either with `docker run` or `docker compose up`. Most Half-Life mods require specific startup arguments. For more details, refer to the [Valve Developer Wiki](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server) and the instructions for the mod you're trying to run.

> [!TIP]  
> When using a pre-built image, you'll likely want to use the `valve` image (`jives/hlds:valve`), but this ultimately depends on the mod.
