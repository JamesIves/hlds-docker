# Agents

> [!NOTE]
> This document is intended for AI agents and tools such as GitHub Copilot. If you're a human, check out the [Getting Started guide](README.md) or the [Contributing guide](CONTRIBUTING.md) instead.

## Repository Overview 📖

This repository provides a Dockerized solution for running the **Half-Life Dedicated Server (HLDS)**, supporting all classic GoldSrc games and mods. The project uses Docker to simplify server setup, with support for custom configurations, plugins, and mods. Pre-built images are published to Docker Hub and GitHub Container Registry via GitHub Actions CI/CD pipelines.

## Technologies 🔧

- **Docker** — Containerizes the HLDS server. The [`Dockerfile`](container/Dockerfile) lives in `container/` and supports build arguments (`GAME`, `FLAG`, `VERSION`, `IMAGE`).
- **Docker Compose** — Two compose files: [`docker-compose.yml`](docker-compose.yml) (root, for end-users pulling pre-built images) and [`container/docker-compose.yml`](container/docker-compose.yml) (for building custom images locally).
- **GitHub Actions** — CI/CD workflows in `.github/workflows/` for validation, beta publishing, production publishing, sponsor management, and PR labeling.
- **Shell Scripting** — [`container/entrypoint.sh`](container/entrypoint.sh) handles runtime initialization (mod syncing, config syncing, server startup).
- **SteamCMD** — Downloads HLDS game files during the Docker build via the [`container/hlds.txt`](container/hlds.txt) script.

## Project Structure 📂

```
├── AGENTS.md                        # This file
├── ARCHITECTURE.md                  # Architecture documentation with diagrams
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
│   ├── entrypoint.sh                # Runtime: validates args, syncs mods/config, starts hlds_run
│   ├── hlds.txt                     # SteamCMD install script (app 90, runs 3x for reliability)
│   ├── docker-compose.yml           # For building custom images locally
│   ├── config/                      # Default configs baked into the image
│   │   ├── server.cfg               # Default hostname and contact
│   │   ├── autoexec.cfg             # Executes default.cfg
│   │   ├── default.cfg              # Empty placeholder for user customization
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

| Game Identifier   | Game Name                          | Legacy Available |
| ----------------- | ---------------------------------- | ---------------- |
| `valve`           | Half-Life Deathmatch               | Yes              |
| `cstrike`         | Counter-Strike                     | Yes              |
| `czero`           | Counter-Strike: Condition Zero     | Yes              |
| `dmc`             | Deathmatch Classic                 | No               |
| `gearbox`         | Half-Life: Opposing Force          | No               |
| `ricochet`        | Ricochet                           | No               |
| `dod`             | Day of Defeat                      | No               |
| `tfc`             | Team Fortress Classic              | Yes              |

Legacy variants use the `-beta steam_legacy` flag to install the pre-25th Anniversary Edition of the game.

## Key Build Arguments 🏗️

| Argument  | Purpose                                                                 | Default   |
| --------- | ----------------------------------------------------------------------- | --------- |
| `GAME`    | GoldSrc game/mod identifier passed to SteamCMD                         | `valve`   |
| `FLAG`    | Additional SteamCMD flags (e.g., `-beta steam_legacy`)                  | _(empty)_ |
| `VERSION` | Semantic version tag, set by CI                                         | `custom`  |
| `IMAGE`   | Full image name with tag, used in the entrypoint startup banner         | `custom`  |

## Runtime Volume Mounts 💾

| Host Path  | Container Path   | Purpose                                                                |
| ---------- | ---------------- | ---------------------------------------------------------------------- |
| `./config` | `/temp/config`   | Config files synced into `/opt/steam/hlds/$GAME/` on container start   |
| `./mods`   | `/temp/mods`     | Mod directories synced into `/opt/steam/hlds/` on container start      |

## Network Ports 🌐

| Port    | Protocol | Purpose                 |
| ------- | -------- | ----------------------- |
| `27015` | TCP/UDP  | Game server traffic     |
| `26900` | UDP      | Steam master server     |

## Entrypoint Behavior 🚪

1. Warns if no `+map` argument is found in the startup command.
2. Syncs files from `/temp/mods` → `/opt/steam/hlds/` using `rsync`.
3. Syncs files from `/temp/config` → `/opt/steam/hlds/$GAME/` using `rsync`.
4. Prints a branded startup banner with image, version, and game info.
5. Launches `hlds_run` with the specified game and all passed arguments.

## CI/CD Workflows 🔄

### [`validate.yml`](.github/workflows/validate.yml) — Validation

- **Trigger**: Push to any branch except `main` and `beta`, or manual dispatch.
- **Matrix**: All 12 game variants (8 games + 4 legacy).
- **Steps**: Build image → create test config/mod files → run container → validate directory mappings and game data → cleanup.

### [`beta.yml`](.github/workflows/beta.yml) — Beta Publishing

- **Trigger**: Push to `beta` branch.
- **Matrix**: All 12 game variants.
- **Steps**: Build → validate → push to Docker Hub (`jives/hlds:<game>-beta`) and GHCR (`ghcr.io/jamesives/hlds:<game>-beta`).

### [`publish.yml`](.github/workflows/publish.yml) — Production Publishing

- **Trigger**: Manual dispatch (`workflow_dispatch`) with a required `version` input.
- **Jobs**:
  1. `build` — For each game variant: build → validate → push to Docker Hub and GHCR with both `<game>` and `<game>-<version>` tags.
  2. `publish` — Creates the GitHub Release and associated version tag from the supplied `version` input.

### [`sponsors.yml`](.github/workflows/sponsors.yml) — Sponsor Management

- **Trigger**: Daily cron + manual dispatch.
- **Steps**: Generates sponsor avatars in [`README.md`](README.md), deploys to `beta` branch.

### [`label.yml`](.github/workflows/label.yml) — PR Labeling

- **Trigger**: Pull request events.
- **Steps**: Auto-assigns labels based on conventional commit prefixes in PR titles.

## Contribution Flow 🤝

1. Issues/discussions are filed on GitHub.
2. Contributors branch from `beta`.
3. Push triggers [`validate.yml`](.github/workflows/validate.yml) for automated testing.
4. PRs merge into `beta` → triggers [`beta.yml`](.github/workflows/beta.yml) → publishes `-beta` tagged images.
5. Maintainer manually triggers [`publish.yml`](.github/workflows/publish.yml) via `workflow_dispatch` with a version input → builds and validates all variants → pushes production images → creates a GitHub Release.

## Coding Conventions 📏

- The [`Dockerfile`](container/Dockerfile) runs as a non-root `steam` user for security.
- SteamCMD `app_update` runs 3 times in [`hlds.txt`](container/hlds.txt) for download reliability.
- Config files use `rsync` for syncing to preserve directory structure and handle overwrites.
- All OCI labels are applied to images for discoverability.
- Legacy game variants strip the `-legacy` suffix before passing to SteamCMD, using the `FLAG` variable to select the beta branch instead.
- The `container/config/` directory contains defaults baked into every image; the root `config/` directory is for user overrides at runtime and is gitignored.
- The `container/mods/` directory is for mods baked into custom builds; the root `mods/` directory is for user mods at runtime and is gitignored.

## Architecture Maintenance 🏛️

[`ARCHITECTURE.md`](ARCHITECTURE.md) should be kept up to date with any major architectural changes. When modifying the build process, entrypoint behavior, CI/CD pipeline, volume mapping strategy, or container file system layout, update the corresponding diagrams and descriptions in [`ARCHITECTURE.md`](ARCHITECTURE.md). During code reviews, reviewers should check that [`ARCHITECTURE.md`](ARCHITECTURE.md) still accurately reflects the current state of the project.

[`AGENTS.md`](AGENTS.md) should also be kept up to date when major changes are made. If workflow triggers, supported games, build arguments, volume mounts, ports, entrypoint behavior, or project structure change, update the corresponding sections in this file.

## Resources 📚

- [Getting Started and Usage](README.md)
- [Architecture](ARCHITECTURE.md)
- [Contributing](CONTRIBUTING.md)
- [Server Configs and Plugins](config/README.md)
- [Custom Mods](mods/README.md)
- [Building a Custom Image](container/README.md)
- [Security Policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
