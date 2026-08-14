# Maintenance

<img align="right" width="180" height="auto"  src="./.github/docs/docker.svg" alt="Docker in the Half-Life Colours">

Once your server is running, here's how to keep its game files current, monitor it, feed its logs into external tools, and keep RCON credentials out of plaintext.

## Keeping Game Files Updated 🔄

Game files are only installed at build time, so restarting a container won't pick up a new Valve patch on its own. Set the `AUTO_UPDATE` environment variable to have the container re-check Steam for updates every time it starts:

```bash
docker run -d -ti \
  --name hlds \
  --restart unless-stopped \
  -e AUTO_UPDATE=true \
  -v "$(pwd)/config:/temp/config" \
  -v "$(pwd)/mods:/temp/mods" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  -p 26900:26900/udp \
  jives/hlds:valve \
  "+log on +rcon_password changeme +maxplayers 12 +map crossfire"
```

> [!NOTE]  
> This adds a network dependent SteamCMD check to every container start, and means the same running container can end up on different game binaries over time. Container registry images are checked on a weekly schedule and refreshed if an update is released by Valve.

## Health Checks 🩺

The image ships with a Docker [`HEALTHCHECK`](https://docs.docker.com/reference/dockerfile/#healthcheck) that polls the running server every 30 seconds so Docker (and anything watching container health, like `docker ps`, Compose, Swarm, or Kubernetes) can tell a hung or crashed server apart from one that's just still loading a map. The status shows up next to your container:

```bash
docker ps
```

Or you can inspect it directly:

```bash
docker inspect --format='{{.State.Health.Status}}' hlds
```

> [!NOTE]  
> The health check queries port `27015` by default. If you've changed the server's port with `+port`, set a matching `PORT` environment variable (e.g. `-e PORT=27016`) so it checks the right one.

## Forwarding Logs 📊

To feed server logs into an external stats tracker (like HLstatsX:CE), add `+logaddress <ip> <port>` to your startup command alongside `+log on` - HLDS will UDP-broadcast its log lines to that address.

```bash
"+log on +logaddress 203.0.113.10 27500 +rcon_password changeme +maxplayers 12 +map crossfire"
```

## RCON Password via a Secret File 🔒

`+rcon_password` in the startup command is visible to anyone who can run `docker inspect` or `docker ps` on the host. To avoid that, set `RCON_PASSWORD_FILE` to a path containing the password instead, and drop `+rcon_password` from the command entirely:

```bash
docker run -d -ti \
  --name hlds \
  --restart unless-stopped \
  -e RCON_PASSWORD_FILE=/run/secrets/rcon_password \
  -v "$(pwd)/rcon_password.txt:/run/secrets/rcon_password:ro" \
  -p 27015:27015/udp \
  -p 27015:27015 \
  jives/hlds:valve \
  "+log on +maxplayers 12 +map crossfire"
```

This works the same way with [Docker Compose secrets](https://docs.docker.com/compose/how-tos/use-secrets/) or Swarm secrets - point `RCON_PASSWORD_FILE` at wherever the secret gets mounted (typically `/run/secrets/<name>`).

## Resources 📚

- [Getting Started and Usage](README.md)
- [Server Configs and Plugins](config/README.md)
- [Custom Mods](mods/README.md)
- [Building a Custom Image](container/README.md)
- [Contributing](CONTRIBUTING.md)
