# Agents

<img align="right" width="180" height="auto"  src="./.github/docs/docker.svg" alt="Docker in the Half-Life Colours">

> [!NOTE]
> This document is intended for AI agents and tools such as GitHub Copilot. If you're a human, check out the [Getting Started guide](README.md) or the [Contributing guide](CONTRIBUTING.md) instead.

## Repository Overview 📖

This repository provides a Dockerised solution for running the **Half-Life Dedicated Server (HLDS)**, supporting all classic GoldSrc games and mods. The project uses Docker to simplify server setup, with support for custom configurations, plugins, and mods. Pre-built images are published to Docker Hub and GitHub Container Registry via GitHub Actions CI/CD pipelines.

## Technologies 🔧

- **Docker**: Containerises the HLDS server. The [`Dockerfile`](container/Dockerfile) lives in `container/` and supports build arguments (`GAME`, `FLAG`, `VERSION`, `IMAGE`).
- **Docker Compose**: Two compose files: [`docker-compose.yml`](docker-compose.yml) (root, for end-users pulling pre-built images) and [`container/docker-compose.yml`](container/docker-compose.yml) (for building custom images locally).
- **GitHub Actions**: CI/CD workflows in `.github/workflows/` for validation, beta publishing, production publishing, sponsor management, and PR labeling.
- **Shell Scripting**: [`container/entrypoint.sh`](container/entrypoint.sh) handles runtime initialisation (mod syncing, config syncing, server startup).
- **SteamCMD**: Downloads HLDS game files during the Docker build via the [`container/hlds.txt`](container/hlds.txt) script.

## Project Structure 📂

```
├── AGENTS.md                        # This file
├── ARCHITECTURE.md                  # Architecture documentation with diagrams
├── MAINTENANCE.md                   # Health checks, log forwarding, RCON secrets
├── .github/
│   ├── workflows/
│   │   ├── validate.yml             # CI: builds and validates all 12 game variants
│   │   ├── publish.yml              # CD: version bump → build → test → push to registries → GitHub release
│   │   ├── beta.yml                 # CD: builds and pushes beta-tagged images
│   │   ├── sponsors.yml             # Updates README with GitHub Sponsors
│   │   └── label.yml                # Auto-labels PRs via conventional commits
│   ├── ISSUE_TEMPLATE/              # Bug report form and config
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── CODEOWNERS                   # @JamesIves owns all files
│   ├── dependabot.yml               # Weekly updates for Actions and Docker
│   ├── release.yml                  # Changelog categories for releases
│   └── FUNDING.yml                  # GitHub Sponsors
├── container/                       # Docker build context
│   ├── Dockerfile                   # Ubuntu base, SteamCMD, HLDS
│   ├── entrypoint.sh                # Runtime: validates args, optional AUTO_UPDATE, syncs mods/config, starts hlds_run
│   ├── healthcheck.sh               # Docker HEALTHCHECK: raw A2S_INFO query over UDP via /dev/udp
│   ├── hlds.txt                     # SteamCMD install script (app 90, runs 3x for reliability)
│   ├── docker-compose.yml           # For building custom images locally
│   ├── config/                      # Default configs baked into the image
│   │   ├── server.cfg               # Default hostname and contact
│   │   ├── autoexec.cfg             # Executes default.cfg
│   │   ├── default.cfg              # Empty placeholder for user customisation
│   │   └── motd.txt                 # HTML message of the day
│   └── mods/                        # Empty by default; mods baked into custom builds go here
├── config/                          # User-provided configs (volume-mounted at runtime, gitignored)
├── mods/                            # User-provided mods (volume-mounted at runtime, gitignored)
├── docker-compose.yml               # End-user compose file pulling pre-built images
├── docs/
│   └── index.html                   # Retro-styled web UI for generating Docker commands
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
└── LICENSE                          # MIT
```

## Supported Games 🎮

All images use SteamCMD app ID `90` with a `mod` config to select the game variant:

| Game Identifier | Game Name                      | Legacy Available |
| --------------- | ------------------------------ | ---------------- |
| `valve`         | Half-Life Deathmatch           | Yes              |
| `cstrike`       | Counter-Strike                 | Yes              |
| `czero`         | Counter-Strike: Condition Zero | Yes              |
| `dmc`           | Deathmatch Classic             | No               |
| `gearbox`       | Half-Life: Opposing Force      | No               |
| `ricochet`      | Ricochet                       | No               |
| `dod`           | Day of Defeat                  | No               |
| `tfc`           | Team Fortress Classic          | Yes              |

Legacy variants use the `-beta steam_legacy` flag to install the pre-25th Anniversary Edition of the game.

## Key Build Arguments 🏗️

| Argument  | Purpose                                                         | Default   |
| --------- | --------------------------------------------------------------- | --------- |
| `GAME`    | GoldSrc game/mod identifier passed to SteamCMD                  | `valve`   |
| `FLAG`    | Additional SteamCMD flags (e.g., `-beta steam_legacy`)          | _(empty)_ |
| `VERSION` | Semantic version tag, set by CI                                 | `custom`  |
| `IMAGE`   | Full image name with tag, used in the entrypoint startup banner | `custom`  |

## Runtime Volume Mounts 💾

| Host Path  | Container Path | Purpose                                                              |
| ---------- | -------------- | -------------------------------------------------------------------- |
| `./config` | `/temp/config` | Config files synced into `/opt/steam/hlds/$GAME/` on container start |
| `./mods`   | `/temp/mods`   | Mod directories synced into `/opt/steam/hlds/` on container start    |

## Runtime Environment Variables 🔧

| Variable             | Purpose                                                                     | Default   |
| --------------------- | ---------------------------------------------------------------------------- | --------- |
| `AUTO_UPDATE`         | If `1`/`true`, re-runs SteamCMD on every container start to refresh game files | _(unset)_ |
| `RCON_PASSWORD_FILE`  | Path to a mounted secret file; its contents become `+rcon_password`, avoiding a plaintext CLI arg | _(unset)_ |
| `PORT`                | Port `healthcheck.sh` queries with `A2S_INFO`; set this if `+port` was changed | `27015`   |

## Network Ports 🌐

| Port    | Protocol | Purpose             |
| ------- | -------- | -------------------- |
| `27015` | TCP/UDP  | Game server traffic and RCON |
| `26900` | UDP      | Steam master server |

## Entrypoint Behaviour 🚪

1. Warns if no `+map` argument is found in the startup command.
2. Warns if `+rcon_password` is still set to the doc/example default `changeme`.
3. If `RCON_PASSWORD_FILE` is set and exists, reads the password from that file and appends `+rcon_password` (a user-supplied `+rcon_password` in the command still wins, since it's applied last).
4. If `AUTO_UPDATE` is set, re-runs SteamCMD against the persisted install directory before syncing mods/config, so a restart alone can pick up a new Valve patch.
5. Syncs files from `/temp/mods` → `/opt/steam/hlds/` using `rsync`.
6. Syncs files from `/temp/config` → `/opt/steam/hlds/$GAME/` using `rsync`.
7. Prints a branded startup banner with image, version, and game info.
8. Launches `hlds_run` with the specified game and all passed arguments.

Independently of the entrypoint, Docker polls [`healthcheck.sh`](container/healthcheck.sh) on a fixed schedule (30s interval, 5s timeout, 60s start period, 3 retries) to report container health via `HEALTHCHECK`.

## CI/CD Workflows 🔄

### [`validate.yml`](.github/workflows/validate.yml): Validation

- **Trigger**: Push to any branch except `main` and `beta`, or manual dispatch.
- **Matrix**: All 12 game variants (8 games + 4 legacy).
- **Steps**: Build image → create test config/mod files → run container → validate directory mappings and game data → cleanup.

### [`beta.yml`](.github/workflows/beta.yml): Beta Publishing

- **Trigger**: Push to `beta` branch.
- **Matrix**: All 12 game variants.
- **Steps**: Build → validate → push to Docker Hub (`jives/hlds:<game>-beta`) and GHCR (`ghcr.io/jamesives/hlds:<game>-beta`).

### [`publish.yml`](.github/workflows/publish.yml): Production Publishing

- **Trigger**: Manual dispatch (`workflow_dispatch`) from `beta` with a `bump` choice (patch/minor/major), or a weekly `schedule` that rebuilds `main` as-is against the current Steam depot.
- **Jobs**:
  1. `check-for-updates` (schedule only): queries Steam's `app_info` and stops the run if nothing changed since the last release.
  2. `version`: computes the next semantic version from the last GitHub Release.
  3. `prepare` (dispatch only): merges `beta` into a scratch `release-candidate` ref.
  4. `test`: builds and validates all 12 game variants (Trivy scan + smoke test) against the candidate (dispatch) or `main` (schedule).
  5. `merge` (dispatch only): fast-forwards `main` to the tested candidate.
  6. `release`: builds and pushes all 12 variants to Docker Hub and GHCR with both `<game>` and `<game>-<version>` tags, and attests provenance.
  7. `publish`: creates the GitHub Release and version tag.

### [`sponsors.yml`](.github/workflows/sponsors.yml): Sponsor Management

- **Trigger**: Daily cron + manual dispatch.
- **Steps**: Generates sponsor avatars in [`README.md`](README.md), deploys to `beta` branch.

### [`label.yml`](.github/workflows/label.yml): PR Labeling

- **Trigger**: Pull request events.
- **Steps**: Auto-assigns labels based on conventional commit prefixes in PR titles.

## Contribution Flow 🤝

1. Issues/discussions are filed on GitHub.
2. Contributors branch from `beta`.
3. Push triggers [`validate.yml`](.github/workflows/validate.yml) for automated testing.
4. PRs merge into `beta` → triggers [`beta.yml`](.github/workflows/beta.yml) → publishes `-beta` tagged images.
5. Maintainer manually triggers [`publish.yml`](.github/workflows/publish.yml) via `workflow_dispatch` with a `bump` choice → merges `beta` into `main` → builds and validates all variants → pushes production images → creates a GitHub Release. The same workflow also runs weekly on its own to rebuild `main` against the current Steam depot when Valve ships an update, without promoting any new code.

## Coding Conventions 📏

- Code comments and documentation (READMEs, `AGENTS.md`, `ARCHITECTURE.md`, `CODE_OF_CONDUCT.md`, etc.) must use British English spelling (e.g., `colour`, `behaviour`, `licence` as a noun, `synchronise`). This doesn't apply to identifiers, fixed spec fields, or external API names that are spelled in American English (e.g., the OCI `org.opencontainers.image.licenses` label, or the `synchronize` pull request event type) - those must stay as-is to remain valid.
- The [`Dockerfile`](container/Dockerfile) runs as a non-root `steam` user for security.
- SteamCMD `app_update` runs 3 times in [`hlds.txt`](container/hlds.txt) for download reliability.
- Config files use `rsync` for syncing to preserve directory structure and handle overwrites.
- All OCI labels are applied to images for discoverability.
- Legacy game variants strip the `-legacy` suffix before passing to SteamCMD, using the `FLAG` variable to select the beta branch instead.
- The `container/config/` directory contains defaults baked into every image; the root `config/` directory is for user overrides at runtime and is gitignored.
- The `container/mods/` directory is for mods baked into custom builds; the root `mods/` directory is for user mods at runtime and is gitignored.

## Architecture Maintenance 🏛️

[`ARCHITECTURE.md`](ARCHITECTURE.md) should be kept up to date with any major architectural changes. When modifying the build process, entrypoint behaviour, CI/CD pipeline, volume mapping strategy, or container file system layout, update the corresponding diagrams and descriptions in [`ARCHITECTURE.md`](ARCHITECTURE.md). During code reviews, reviewers should check that [`ARCHITECTURE.md`](ARCHITECTURE.md) still accurately reflects the current state of the project.

[`AGENTS.md`](AGENTS.md) should also be kept up to date when major changes are made. If workflow triggers, supported games, build arguments, volume mounts, ports, entrypoint behaviour, or project structure change, update the corresponding sections in this file.

## Resources 📚

- [Getting Started and Usage](README.md)
- [Architecture](ARCHITECTURE.md)
- [Contributing](CONTRIBUTING.md)
- [Server Configs and Plugins](config/README.md)
- [Custom Mods](mods/README.md)
- [Building a Custom Image](container/README.md)
- [Server Maintenance](MAINTENANCE.md)
- [Security Policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
